addin.run.do.file = function() {
  doc = rstudioapi::getSourceEditorContext()
  file = doc$path
  ext = tolower(tools::file_ext(file))
  if (ext != "do" & ext != "ado") {
    cat("\nYou have no do file active in your RStudio editor.")
  }
  id = terminalVisible()
  rstudioapi::terminalSend(id,paste0("do ", file,"\n"))
}

addin.start.stata.console = function() {
  library(rstudioapi)
  id = terminalCreate(show = TRUE)
  rstudioapi::terminalSend(id,"stata\n")
  terminalActivate(id)

  Sys.sleep(1)
  dir = getwd()
  rstudioapi::terminalSend(id,paste0("cd ",dir,"\n"))
  rstudioapi::terminalSend(id,paste0(
"* To paste a line from a do file open in your RStudio editor to Stata,
* put the cursor on that line and press Ctrl-Alt-Enter.
"))
  terminalActivate(id)

}

addin.view.stata.data = function() {
  temp.file = tempfile(fileext = ".dta")
  cmd = paste0("save ", temp.file,"\n")
  library(rstudioapi)
  rstudioapi::terminalSend(terminalVisible(),cmd)
  stata_data = haven::read_dta(temp.file)
  file.remove(temp.file)
  View(stata_data)
}
