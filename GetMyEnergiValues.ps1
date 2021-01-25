    
   
    $username = "your_myenergihubserial"
    $password = "your_password"

    #Harvi - make sure url (specifically the"1") is correct
    $baseuri  = "https://s1.myenergi.net/cgi-jstatus-H"   
          
    $uri = New-Object System.Uri ($baseuri+"digest-auth/auth/" + $username + "/" + $password) 
    $secpasswd = ConvertTo-SecureString $password -AsPlainText -Force 
    $mycreds = New-Object System.Management.Automation.PSCredential ($username, $secpasswd)

    #Zappi - make sure url (specifically the"1") is correct
    $baseuriZ = "https://s1.myenergi.net/cgi-jstatus-Z"
     
    $uriZ = New-Object System.Uri ($baseuriZ+"digest-auth/auth/" + $username + "/" + $password) 
    $secpasswdZ = ConvertTo-SecureString $password -AsPlainText -Force 
    $mycredsZ = New-Object System.Management.Automation.PSCredential ($username, $secpasswd)
    
    #Get values and parse json
    do  {
          #Zappi
          $rZ = Invoke-WebRequest -Uri $uriZ.AbsoluteUri -Credential $mycreds
          $rjsonZ = ConvertFrom-Json $rZ.Content
          $vol = $rjsonZ.zappi.vol
          $frequency = $rjsonZ.zappi.frq
          $grid = [Math]::Round($rjsonZ.zappi.grd/1000,2)
          $volt = $rjsonZ.zappi.vol
          $charge = [Math]::Round($rjsonZ.zappi.div/1000,2)
          $chargeA = [Math]::Round($rjsonZ.zappi.div/$volt,1)
          
          #Harvi
          $r = Invoke-WebRequest -Uri $uri.AbsoluteUri -Credential $mycreds
          $rjson = ConvertFrom-Json $r.Content
          $ectp1 = [math]::Round($rjson.harvi.ectp1/1000,2)
          $ectp2 = [math]::Round($rjson.harvi.ectp2/1000,2)
          $ectp3 = [math]::Round($rjson.harvi.ectp3/1000,2)
          $i1 = [math]::Round($rjson.harvi.ectp1/$vol,1)
          $i2 = [math]::Round($rjson.harvi.ectp2/$vol,1)
          $i3 = [math]::Round($rjson.harvi.ectp3/$vol,1)
          $date = Get-Date
          $dateF = $date.ToString("yyyy-MM-dd HH:mm:ss")
          
          Write-Host $dateF
          Write-Host ("Grid   $grid kW $vol V")
          Write-Host ("Charge $charge kW $chargeA A")
          Write-Host ("L1/2/3 $ectp1 kW / $ectp2 kW / $ectp3 kW")
          Write-Host ("L1/2/3 $i1 A / $i2 A / $i3 A")
          Write-Host ("")
          
          # Create text file for this reading
          $filetext = " $dateF `r` Grid   $grid kW $vol V `r` Charge $charge kW $chargeA A `r` L1/2/3 $ectp1 kW / $ectp2 kW / $ectp3 kW `r` L1/2/3 $i1 A / $i2 A / $i3 A"
          .\CreateMyEnergiFile.ps1 -text $filetext

          #Call python to store to DB
          #Args
          #(DT, GridkW, GridV, ChargekW, ChargeA, L1kW, L2kW, L3kW, L1A, L2A, L3A)
          python SQL_InsertBasic.py($dateF, $grid, $vol, $charge, $chargeA, $ectp1, $ectp2, $ectp3, $i1, $i2,$i3)

          start-sleep 30
        } While ($loop_Forever = 'true')