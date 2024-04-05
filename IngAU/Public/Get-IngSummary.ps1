function Get-IngSummary {
    $summary = Invoke-IngApi -Endpoint '/api/Dashboard/Service/DashboardService.svc/json/Dashboard/loaddashboard'
    $summary.Response
}
