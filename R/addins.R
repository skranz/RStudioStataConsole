addind.set.stata.dir.to.source.file = function() {
  doc = rstudioapi::getSourceEditorContext()
  file = doc$path
  path = dirname(file)
  id = terminalVisible()
  rstudioapi::terminalSend(id,paste0("cd ", path,"\n"))
}v

addin.run.do.file = function() {
  doc = rstudioapi::getSourceEditorContext()
  file = doc$path
  ext = tolower(tools::file_ext(file))
  cat("\n",file)
  id = terminalVisible()
  if (!isTRUE(ext == "do" | ext == "ado")) {
    cat("\nYou have no do file active in your RStudio editor.")
    rstudioapi::terminalSend(id,paste0("* You have no do file active in your RStudio editor.\n"))
    return(invisible())
  }
  terminalActivate(id)
  rstudioapi::terminalSend(id,paste0("do ", file,"\n"))
  return(invisible())
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
  cmd = paste0("save ", temp.file, "\n")
  library(rstudioapi)
  rstudioapi::terminalSend(terminalVisible(), cmd)
  time.out = 5
  start.time = Sys.time()
  while (TRUE) {
    stata_data = try(haven::read_dta(temp.file),silent = TRUE)
    if (!is(stata_data,"try-error")) {
      .GlobalEnv$stata_data = stata_data
      file.remove(temp.file)
      View(stata_data)
      return()
    }
    if (as.numeric(Sys.time() - start.time) > time.out)
      break
  }
  cat("\n\nTime out after 5 seconds. Your Stata data set seems to large or some other error occured. Call manually in your Stata console save with a filename to write to a .dta file which you can  read from R.")
  return()
}
