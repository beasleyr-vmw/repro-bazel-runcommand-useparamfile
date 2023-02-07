def _impl(ctx):
    out = ctx.actions.declare_file("output")

    out_args = ctx.actions.args()
    out_args.add(out.path)

    paramfile_args = ctx.actions.args()
    paramfile_args.use_param_file("@%s", use_always=True)
    paramfile_args.add("dummy")
    paramfile_args.add("dummy2")

    ctx.actions.run_shell(
        arguments = [out_args, paramfile_args],
        outputs = [out],
        command = """
set -x
out=$1; shift
paramarg=$1; shift
[[ "$paramarg" =~ ^@ ]] && touch $out
""",
    )
    return DefaultInfo(files=depset([out]))

repro = rule(implementation = _impl)
