import genieos, argument_parser, tables

const
  PARAM_VERBOSE = @["-v", "--verbose"]
  PARAM_HELP = @["-h", "--help"]

proc process_commandline(): Tcommandline_results =
  var params: seq[Tparameter_specification] = @[]
  params.add(new_parameter_specification(names = PARAM_VERBOSE,
    help_text = "Be verbose about files being recycled"))
  params.add(new_parameter_specification(names = PARAM_HELP,
    help_text = "Be verbose about files being recycled", consumes = PK_HELP))

  result = parse(params)

  if result.positional_parameters.len < 1:
    echo "Please specify a file or directory to send to the recycle bin"
    echo_help(params)
    quit()


proc process(filename: string, verbose: bool) =
  if verbose:
    echo "Recycling " & filename
  try:
    recycle filename
  except EOS:
    echo "Sorry, could not recycle " & filename


when isMainModule:
  let args = process_commandline()
  for param in args.positional_parameters:
    process param.str_val, args.options.hasKey(PARAM_VERBOSE[0])
