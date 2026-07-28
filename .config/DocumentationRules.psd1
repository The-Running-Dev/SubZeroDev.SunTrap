@{
    Terminology = @(
        @{ Required = 'GitHub'; Variants = @('Github', 'GitHUB', 'Git Hub') }
        @{ Required = 'PowerShell'; Variants = @('Powershell', 'Power Shell') }
        @{ Required = 'TypeScript'; Variants = @('Typescript', 'Type Script') }
        @{ Required = 'Node.js'; Variants = @('NodeJS', 'Nodejs', 'node js') }
        @{ Required = 'Docusaurus'; Variants = @('DocuSaurus', 'docusaurus') }
        @{ Required = 'Dockerfile'; Variants = @('DockerFile', 'docker file', 'Docker file') }
        @{ Required = 'YAML'; Variants = @('Yaml', 'yaml file') }
    )

    ExcludedSegments = @('.git', 'artifacts', 'build', 'coverage', 'dist', 'node_modules')

    GeneratedFiles = @(
        @{
            Path = 'documentation/index.md'
            Source = 'README.md'
            Generator = 'build/ConvertTo-DocumentationHomepage.ps1'
            SourceParameter = 'ReadmePath'
            Arguments = @{
                Title = 'Sun Trap'
                Description = 'A satirical resort-management simulation'
                SiteUrl = 'https://suntrap.subzerodev.com/'
                RouteBasePath = '/'
            }
        }
        @{
            Path = 'documentation/src/pages/index.md'
            Source = 'README.md'
            Generator = 'build/ConvertTo-DocumentationHomepage.ps1'
            SourceParameter = 'ReadmePath'
            Arguments = @{
                Title = 'Sun Trap'
                Description = 'A satirical resort-management simulation'
                SiteUrl = 'https://suntrap.subzerodev.com/'
                RouteBasePath = 'docs'
            }
        }
    )

    ExcludedFiles = @()
}
