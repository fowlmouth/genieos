import genieos, argument_parser, tables, os

const
  PARAM_SILENT = @["-s", "--silent"]
  PARAM_VERBOSE = @["-v", "--verbose"]
  PARAM_HELP = @["-h", "--help"]

proc process_commandline(): Tcommandline_results =
  var params: seq[Tparameter_specification] = @[]
  params.add(new_parameter_specification(names = PARAM_VERBOSE,
    help_text = "Be verbose about files being recycled"))
  params.add(new_parameter_specification(names = PARAM_HELP,
    help_text = "Be verbose about files being recycled", consumes = PK_HELP))
  params.add(new_parameter_specification(names = PARAM_SILENT,
    help_text = "Don't trigger OS sounds during recycle bin operations"))

  result = parse(params)

  if result.positional_parameters.len < 1:
    echo "Please specify a file or directory to send to the recycle bin"
    echo_help(params)
    quit()


proc process(filename: string, verbose: bool): bool =
  ## Recycles the specified path.
  ##
  ## If verbose is true, it means the path was recycled correctly.
  if verbose:
    echo "Recycling " & filename
  try:
    recycle filename
    result = true
  except EOS:
    echo "Sorry, could not recycle " & filename


when isMainModule:
  let args = process_commandline()
  var count = 0
  for param in args.positional_parameters:
    if process(param.str_val, args.options.hasKey(PARAM_VERBOSE[0])):
      count += 1
  if count > 0 and not args.options.hasKey(PARAM_SILENT[0]):
    let wait = playSound(recycleBin)
    sleep(int(1000 * wait))
