
//  Created by Elliott French on 13/11/2015.
//  Copyright © 2015 Elliott French. All rights reserved.

//  The MIT License (MIT)
//
//  Copyright (c) 2015 Elliott French
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import Foundation

// ******************************************************************************************************************************************************
// MARK: - Snippet Properties and Initialisers

class Snippet: CustomStringConvertible {
    
    var description: String {
        get { return "Id: \(identifier), Title: \(title)" }
    }
    
    internal let shortcut: String
    internal let completionScopes: [String]
    internal let content: String
    internal let identifier: String
    internal let language: String = "Swift"
    internal let platform: String
    internal let summary: String
    internal let title: String
    internal let version: Int
    
    init(shortcut: String,
        completionScopes: [String],
        content: String,
        identifier: String,
        platform: String,
        summary: String,
        title: String,
        version: Int) {
            
            // Normalise listed scopes
            var scopes: [String] = []
            for scope in completionScopes {
                switch scope.lowercaseString {
                case "class implementation":
                    scopes.append("ClassImplementation")
                case "code expression":
                    scopes.append("CodeExpression")
                case "function or method":
                    scopes.append("CodeBlock")
                case "string or comment":
                    scopes.append("StringOrComment")
                case "top level":
                    scopes.append("TopLevel")
                default:
                    scopes.append("All")
                }
            }
            self.completionScopes = scopes

            // Normalise provided platform
            switch platform.lowercaseString {
            case "ios":
                self.platform = "iphoneos"
            case "osx":
                self.platform = "macosx"
            case "tvos":
                self.platform = "appletvos"
            case "watchos":
                self.platform = "watchos"
            default:
                self.platform = "all"
            }
            
            self.shortcut = shortcut
            self.content = content
            self.identifier = identifier
            self.summary = summary
            self.title = title
            self.version = version
    }
}

// ******************************************************************************************************************************************************
// MARK: - SnippetManager Error Handling Enum

enum ManagerError : ErrorType {
    case InvalidNumberOfTerminalArguments
    case FailedToProcessTerminalArguments
    case FailedToAccessUserVariable
    case FailedToAccessXcodeSnippetDirectory
    case FailedToAccessImportSnippetDirectory
    case MalformedImportURL
    case MalformedXcodeURL
    case FailedToReadSnippetFile
}

// ******************************************************************************************************************************************************
// MARK: - SnippetManager Text Processing Helper Enum

enum PropertyProcessing {
    case Searching
    case Reading
    case Closed
}

// ******************************************************************************************************************************************************
// MARK: - SnippetManager Properties and Initialisers

class SnippetManager {
    
    private let currentPath: String = NSFileManager.defaultManager().currentDirectoryPath
    private var importSnippetPath: NSURL!
    private var xcodeSnippetPath: NSURL!
    private var existingSnippetIdentifiers: [String] = []
    
    init() throws {
        guard let user = NSProcessInfo.processInfo().environment["USER"] else { throw ManagerError.FailedToAccessUserVariable }
        guard let xcodeSnippetDir = NSURL(string: "/Users/\(user)/Library/Developer/Xcode/UserData/CodeSnippets") else { throw ManagerError.MalformedXcodeURL }
        guard let importSnippetDir = NSURL(string: currentPath)!.URLByDeletingLastPathComponent else { throw ManagerError.MalformedImportURL }
        
        self.xcodeSnippetPath = xcodeSnippetDir
        self.importSnippetPath = importSnippetDir
        
        // Fetch existing Xcode snippet identifiers
        try fetchExistingXcodeSnippetIdentifiers()
        
    }
    
    private func fetchExistingXcodeSnippetIdentifiers() throws {
        do {
            let xcodeSnippetURLs: [NSURL] = try NSFileManager.defaultManager().contentsOfDirectoryAtURL(xcodeSnippetPath,
                includingPropertiesForKeys: [],
                options: .SkipsHiddenFiles)
            
            for snippetURL in xcodeSnippetURLs {
                if let urlMinusExt = snippetURL.URLByDeletingPathExtension, let identifier = urlMinusExt.lastPathComponent {
                    existingSnippetIdentifiers.append("\(identifier)")
                } else {
                    print("\u{26A0}  WARNING: Unable to update file at - \(snippetURL)")
                    continue
                }
            }
        } catch {
            throw ManagerError.FailedToAccessXcodeSnippetDirectory
        }
    }
    
}

// ******************************************************************************************************************************************************
// MARK: - SnippetManager Functionality

extension SnippetManager {
    
    internal func fetchSnippetFilePathsToImport() throws -> [String] {
        do {
            var importSnippetFilePaths: [String] = []
            let importSnippetURLs: [NSURL] = try NSFileManager.defaultManager().contentsOfDirectoryAtURL(importSnippetPath,
                includingPropertiesForKeys: [],
                options: .SkipsHiddenFiles)
            
            // Return snippet paths for .Swift files
            for snippetURL in importSnippetURLs {
                if let path = snippetURL.path, let ext = snippetURL.pathExtension {
                    if (ext == "swift") {
                        importSnippetFilePaths.append(path)
                    }
                }
            }
            return importSnippetFilePaths
        } catch {
            throw ManagerError.FailedToAccessImportSnippetDirectory
        }
    }
    
    internal func readAndModelSnippetWithPaths(paths: [String]) throws -> [Snippet] {
        do {
            var snippetModels: [Snippet] = []
            
            fileLoop: for filePath in paths {
                
                // File contents
                let contents = try String(contentsOfFile: filePath, encoding: NSUTF8StringEncoding)
                
                // Enumerate file
                var snippetProperties:[String: AnyObject] = [:]
                var snippetText: [String] = []
                var processingStatus: PropertyProcessing = .Searching
                
                contents.enumerateLines { (line, stop) -> () in
                    if (line == "/*---") { processingStatus = .Reading; return }
                    if (line == "---*/") { processingStatus = .Closed; return }
                    
                    switch processingStatus {
                    case .Reading:
                        
                        // Split string
                        let components: [String] = line.componentsSeparatedByString(":")
                        if (components.count != 2) {
                            print("\u{26A0}  WARNING: (\(line) was ignored) - property must conform to" +
                                " 'key:value', update and rerun script.")
                            return
                        }
                        
                        // Remove leading/ trailing whitespace
                        let keyRaw = components[0].stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
                        let key = keyRaw.lowercaseString
                        let value = components[1].stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
                        
                        // Handle possibility of completion-scopes array
                        if (key == "completion-scopes") {
                            let scopeComponents: [String] = value.componentsSeparatedByString(",")
                            var scopes: [String] = []
                            for scopeComponent in scopeComponents {
                                let scope = scopeComponent.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
                                scopes.append(scope)
                            }
                            snippetProperties.updateValue(scopes, forKey: key)
                            return
                        }
                        
                        snippetProperties.updateValue(value, forKey: key)
                        return
                    case .Closed:
                        // Process snippet content text
                        snippetText.append(line + "\n")
                    case .Searching:
                        return
                    }
                }
                
                // Check property dictionary length to ensure snippets aren't created for files without a declared property list
                if (snippetProperties.keys.count == 0) {
                    print("\u{26A0}  WARNING: File at path - \(filePath) was not processed - ensure file contains snippet properties," +
                        " preceded and terminated by '/*---' and '---*/' lines respectively.")
                    continue fileLoop
                }
                
                let shortcut = snippetProperties["shortcut"] as? String ?? ""
                let completionScopes = snippetProperties["completion-scopes"] as? [String] ?? ["All"]
                let content = snippetText.joinWithSeparator("")
                let identifier = snippetProperties["id"] as? String ?? NSUUID().UUIDString
                let platform = snippetProperties["platform"] as? String ?? "All"
                let summary = snippetProperties["summary"] as? String ?? ""
                let title = snippetProperties["title"] as? String ?? ""
                let rawVersion = snippetProperties["version"] as? String ?? "1"
                let version = Int(rawVersion) ?? 1
                
                // Construct model
                let snippet = Snippet(shortcut: shortcut,
                    completionScopes: completionScopes,
                    content: content,
                    identifier: identifier,
                    platform: platform,
                    summary: summary,
                    title: title,
                    version: version)
                
                snippetModels.append(snippet)
            }
            
            return snippetModels
        } catch {
            throw ManagerError.FailedToReadSnippetFile
        }
    }
    
    internal func escapeSnippetContent(content: String) -> String {
        let characters = [ ("&amp;", "&"), ("&quot;", "\""), ("&apos;", "'"), ("&gt;", ">"), ("&lt;", "<")]
        
        var escapedString = content
        for (escapedChar, unescapedChar) in characters {
            escapedString = escapedString.stringByReplacingOccurrencesOfString(unescapedChar,
                withString: escapedChar, options: NSStringCompareOptions.RegularExpressionSearch, range: nil)
        }
        return escapedString
    }
    
    internal func generateXcodeSnippet(snippet: Snippet) -> String {
        let newline = "\n"
        
        // pList key/value pairs
        let fileOpening = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" + newline +
            "<!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">" + newline +
            "<plist version=\"1.0\">" + newline +
            "<dict>" + newline
        let completionPrefix = "<key>IDECodeSnippetCompletionPrefix</key>" + newline +
            "<string>\(snippet.shortcut)</string>" + newline
        
        // Enumerate and append completion-scopes
        var codeSnippetCompletionScopes = ""
        for scope in snippet.completionScopes {
            codeSnippetCompletionScopes += "<string>\(scope)</string>"
        }
        
        let completionScopes = "<key>IDECodeSnippetCompletionScopes</key>" + newline +
            "<array>" + newline + codeSnippetCompletionScopes + newline + "</array>" + newline

        // Escape to XML compliant string
        let escapedContent = escapeSnippetContent(snippet.content)
        
        let content = "<key>IDECodeSnippetContents</key>" + newline + "<string>\(escapedContent)</string>" + newline
        let identifier = "<key>IDECodeSnippetIdentifier</key>" + newline + "<string>\(snippet.identifier)</string>" + newline
        let language = "<key>IDECodeSnippetLanguage</key>" + newline + "<string>Xcode.SourceCodeLanguage.\(snippet.language)</string>" + newline
        let platform = "<key>IDECodeSnippetPlatformFamily</key>" + newline + "<string>\(snippet.platform)</string>" + newline
        let summary = "<key>IDECodeSnippetSummary</key>" + newline + "<string>\(snippet.summary)</string>" + newline
        let title = "<key>IDECodeSnippetTitle</key>" + newline + "<string>\(snippet.title)</string>" + newline
        let isUserDefined = "<key>IDECodeSnippetUserSnippet</key>" + newline + "<true/>" + newline
        let version = "<key>IDECodeSnippetVersion</key>" + newline + "<integer>\(snippet.version)</integer>" + newline
        let fileEnd = "</dict>" + newline + "</plist>"
        
        // Exclude platform key/value if "all"
        if (snippet.platform == "all") {
            return (fileOpening + completionPrefix + completionScopes + content +
                identifier + language + summary + title + isUserDefined + version + fileEnd)
        } else {
            return (fileOpening + completionPrefix + completionScopes + content +
                identifier + language + platform + summary + title + isUserDefined + version + fileEnd)
        }
    }
    
    internal func addSnippet(snippet: Snippet) -> Bool {
        let writePath = "\(xcodeSnippetPath.absoluteString)/\(snippet.identifier).codesnippet"
        let contents = generateXcodeSnippet(snippet)
        let data = contents.dataUsingEncoding(NSUTF8StringEncoding)
        return NSFileManager.defaultManager().createFileAtPath(writePath, contents: data, attributes: nil)
    }
    
}

// ******************************************************************************************************************************************************
// MARK: - Script Execution

do {
    // Arguments
    if (Process.arguments.count != 2) { throw ManagerError.InvalidNumberOfTerminalArguments }
    
    // Initialise Manager
    let manager = try SnippetManager()
    
    // Process arguments
    if let argument = String.fromCString(Process.arguments[1]) {
        var snippetModelsToImport: [Snippet] = []
        switch argument.lowercaseString {
        case "-all", "-a":
            // Fetch file paths for snippets to import
            let snippetPaths = try manager.fetchSnippetFilePathsToImport()
            // Read and Model Snippets to Import
            snippetModelsToImport = try manager.readAndModelSnippetWithPaths(snippetPaths)
        default:
            snippetModelsToImport = try manager.readAndModelSnippetWithPaths([argument])
        }
        
        // Attempt to add snippets to Xcode snippet directory
        for snippet in snippetModelsToImport {
            let isExistingSnippet = manager.existingSnippetIdentifiers.contains(snippet.identifier)
            if (manager.addSnippet(snippet)) {
                (isExistingSnippet) ? print("\u{2705}  UPDATED: \(snippet.identifier)") : print("\u{2705}  ADDED: \(snippet.identifier)")
            } else {
                print("\u{26A0}  WARNING: Unable to write snippet \(snippet.identifier) to Xcode snippet directory.")
            }
        }
        
        print("\u{1F6A7}  NOTE: Restart Xcode to access your updated snippets.")
    } else {
        throw ManagerError.FailedToProcessTerminalArguments
    }
} catch ManagerError.InvalidNumberOfTerminalArguments {
    print("\u{26D4}  ERROR: Please provide either the 'all' argument, to install and update all snippets in the parent directory," +
        " or supply a specific snippet PATH."); exit(0)
} catch ManagerError.FailedToProcessTerminalArguments {
    print("\u{26D4}  ERROR: Unable to process supplied argument. Please provide either the 'all' argument, to install and update all" +
        " snippets in the parent directory, or supply a specific snippet PATH."); exit(0)
} catch ManagerError.FailedToAccessUserVariable {
    print("\u{26D4}  ERROR: Unable to find $USER environment variable for current process."); exit(0)
} catch ManagerError.FailedToAccessXcodeSnippetDirectory {
    print("\u{26D4}  ERROR: Unable to find Xcode snippet directory."); exit(0)
} catch ManagerError.FailedToAccessImportSnippetDirectory {
    print("\u{26D4}  ERROR: Unable to access script's parent directory and therefore any snippets contained."); exit(0)
} catch ManagerError.MalformedImportURL {
    print("\u{26D4}  ERROR: Unable to construct valid URL to parent directory."); exit(0)
} catch ManagerError.MalformedXcodeURL {
    print("\u{26D4}  ERROR: Unable to construct valid URL to Xcode snippet directory."); exit(0)
} catch ManagerError.FailedToReadSnippetFile {
    print("\u{26D4}  ERROR: Failed to read contents of snippet file. Please ensure all snippet files can be encoded with NSUTF8StringEncoding."); exit(0)
}
