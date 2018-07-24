date >>c:\VMReplication_status_log.txt

$currenthostname = hostname
$ServerStatOK = Get-VMReplication | Where-Object {$_.ReplicationHealth -eq "Normal"}

foreach ($i in $ServerStatOK)
    {
    Write-Host $i.VMName $i.ReplicationHealth
    echo $i.VMName "sync status is:" $i.ReplicationHealth >>c:\VMReplication_status_log.txt
    }

$ServerStatWarning = Get-VMReplication | Where-Object {$_.ReplicationHealth -eq "Warning" -and $_.PrimaryServer -Match $_.currenthostname} 

foreach ($i in $ServerStatWarning)
    {
    Write-Host $i.VMName "replicationstatus is" $i.ReplicationHealth
    Write-Output $i.VMName "replicationstatus is" $i.ReplicationHealth >>c:\VMReplication_status_log.txt
    Resume-VMReplication $i.VMName
    Reset-VMReplicationStatistics $i.VMName
    Write-Output $i.VMName "replicationstatus is now" $i.ReplicationHealth >>c:\VMReplication_status_log.txt
    Write-Host $i.VMName "replicationstatus is" $i.ReplicationHealth
    }

$ServerStatCritical = Get-VMReplication | Where-Object {$_.ReplicationHealth -eq "Critical" -and $_.PrimaryServer -Match $_.currenthostname} 

foreach ($i in $ServerStatCritical)
    {
    Write-Host $i.VMName "replicationstatus is" $i.ReplicationHealth
    Write-Output $i.VMName "replicationstatus is" $i.ReplicationHealth >>c:\VMReplication_status_log.txt
    Resume-VMReplication $i.VMName -Resynchronize
    Reset-VMReplicationStatistics $i.VMName
    Write-Output $i.VMName "replicationstatus is now" $i.ReplicationHealth >>c:\VMReplication_status_log.txt
    Write-Host $i.VMName "replicationstatus is" $i.ReplicationHealth
    }

date >>c:\VMReplication_status_log.txt
echo _____SCRIPT_ENDS_HERE_____ >>c:\VMReplication_status_log.txt
