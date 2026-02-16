Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Create form
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$form = New-Object System.Windows.Forms.Form
$form.Text = "File Renamer"
$form.Size = New-Object System.Drawing.Size(460,340)
$form.StartPosition = "CenterScreen"
$form.FormBorderStyle = "FixedDialog"
$form.MaximizeBox = $false
$form.Font = New-Object System.Drawing.Font("Segoe UI",10)

$padding = 20
$controlWidth = 400

# Module Label
$moduleLabel = New-Object System.Windows.Forms.Label
$moduleLabel.Text = "Module (e.g. 10.2)"
$moduleLabel.Location = New-Object System.Drawing.Point($padding,20)
$moduleLabel.AutoSize = $true
$form.Controls.Add($moduleLabel)

# Module Box
$moduleBox = New-Object System.Windows.Forms.TextBox
$moduleBox.Location = New-Object System.Drawing.Point($padding,45)
$moduleBox.Size = New-Object System.Drawing.Size($controlWidth,30)
$form.Controls.Add($moduleBox)

# Title Label
$titleLabel = New-Object System.Windows.Forms.Label
$titleLabel.Text = "Title"
$titleLabel.Location = New-Object System.Drawing.Point($padding,85)
$titleLabel.AutoSize = $true
$form.Controls.Add($titleLabel)

# Title Box
$titleBox = New-Object System.Windows.Forms.TextBox
$titleBox.Location = New-Object System.Drawing.Point($padding,110)
$titleBox.Size = New-Object System.Drawing.Size($controlWidth,30)
$form.Controls.Add($titleBox)

# Checkbox
$todayCheckbox = New-Object System.Windows.Forms.CheckBox
$todayCheckbox.Text = "Only rename today's screenshots"
$todayCheckbox.Location = New-Object System.Drawing.Point($padding,155)
$todayCheckbox.AutoSize = $true
$todayCheckbox.Checked = $true
$form.Controls.Add($todayCheckbox)

# Button
$button = New-Object System.Windows.Forms.Button
$button.Text = "Rename Files"
$button.Location = New-Object System.Drawing.Point($padding,195)
$button.Size = New-Object System.Drawing.Size($controlWidth,40)
$button.FlatStyle = "Flat"
$button.BackColor = "#0078D7"
$button.ForeColor = "White"
$form.Controls.Add($button)

# Button logic
$button.Add_Click({

    $module = $moduleBox.Text.Trim()
    $title = $titleBox.Text.Trim()

    if ([string]::IsNullOrWhiteSpace($module) -or [string]::IsNullOrWhiteSpace($title)) {
        [System.Windows.Forms.MessageBox]::Show("Please enter both Module and Title.","File Renamer")
        return
    }

    $files = Get-ChildItem "$env:USERPROFILE\Downloads\*.png" | Sort-Object CreationTime

    if ($todayCheckbox.Checked) {
        $files = $files | Where-Object { $_.CreationTime.Date -eq (Get-Date).Date }
    }

    if ($files.Count -eq 0) {
        [System.Windows.Forms.MessageBox]::Show("No matching screenshots found.","File Renamer")
        return
    }

    $confirm = [System.Windows.Forms.MessageBox]::Show(
        "Found $($files.Count) files. Proceed?",
        "File Renamer",
        [System.Windows.Forms.MessageBoxButtons]::YesNo
    )

    if ($confirm -ne "Yes") { return }

    $i = 1
    foreach ($file in $files) {
        $newName = "$module.$i - $title.png"
        Rename-Item $file.FullName $newName
        $i++
    }

    [System.Windows.Forms.MessageBox]::Show("Renaming complete!","File Renamer")
})

$form.ShowDialog()