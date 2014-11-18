function analyseCodeAnalysisResults( [Parameter(ValueFromPipeline=$true)]$codeAnalysisResultsFile ) {
  $codeAnalysisErrors = [xml](Get-Content $codeAnalysisResultsFile);

  foreach ($codeAnalysisError in $codeAnalysisErrors.SelectNodes("//Message")) {
    $issueNode = $codeAnalysisError.SelectSingleNode("Issue");
    Write-Host "Violation of Rule $($codeAnalysisError.CheckId): $($codeAnalysisError.TypeName) Line Number: $($issueNode.Line) FileName: $($issueNode.Path)\$($codeAnalysisError.Issue.File) ErrorMessage: $($issueNode.InnerXml)";

    if(isAppVeyor) {
      Add-AppveyorTest "Violation of Rule $($codeAnalysisError.CheckId): $($codeAnalysisError.TypeName) Line Number: $($issueNode.Line)" -Outcome Failed -FileName "$($issueNode.Path)\$($codeAnalysisError.Issue.File)" -ErrorMessage $($issueNode.InnerXml);
    }
  }

  if(isAppVeyor) {
    Push-AppveyorArtifact $codeAnalysisResultsFile;
  }
}


analyseCodeAnalysisResults("src\Bugsnag.Core\bin\Debug\Bugsnag.Core.dll.CodeAnalysisLog.xml")
analyseCodeAnalysisResults("src\Bugsnag.Web\bin\Debug\Bugsnag.Web.dll.CodeAnalysisLog.xml")
