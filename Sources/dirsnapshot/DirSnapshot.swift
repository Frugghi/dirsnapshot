import ArgumentParser
import Foundation
import PathKit
import Stencil

@main
struct DirSnapshot: ParsableCommand {
    @Flag(inversion: .prefixedEnableDisable, help: "Skip hidden files")
    var skipHiddenFiles = true

    @Argument(help: "The path of the directory")
    var input: String

    @Argument(help: "The path of the output file")
    var output: String

    mutating func run() throws {
        let input = Path(input).absolute()
        let output = Path(output).absolute()

        // Check if the output is a folder
        if output.isDirectory {
            throw RuntimeError("The output must be a file, '\(output)' is a folder.")
        }

        // Create the output file
        output.touch()

        // Initialize a generator
        var generator = Snap2HTMLGenerator(
            appName: "dirsnapshot",
            appVersion: "1.0.0",
            appLink: "https://github.com/Frugghi/dirsnapshot",
            title: output.description
        )

        // Visit the input folder
        generator.visit(input)

        // Create the enumeration options
        var enumerationOptions: Path.DirectoryEnumerationOptions = []
        if skipHiddenFiles {
            enumerationOptions.formUnion(.skipsHiddenFiles)
        }

        // Visit all files and subfolders
        for path in input.iterateChildren(options: enumerationOptions) {
            generator.visit(path)
        }

        // Generate the output
        let renderedTemplate = try generator.render()

        // Write the output to disk
        try output.write(renderedTemplate)
    }
}
