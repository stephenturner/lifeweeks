import click
from lifeweeks.plot import create_life_plot
from lifeweeks.utils import validate_date, process_filename
from importlib.metadata import version, PackageNotFoundError

try:
    __version__ = version("lifeweeks")
except PackageNotFoundError:
    __version__ = "unknown"


@click.command(context_settings=dict(help_option_names=["-h", "--help"]))
@click.argument("birthday", type=str)
@click.option(
    "--output",
    "-o",
    default="lifeweeks.pdf",
    help="Output filename (default: lifeweeks.pdf)",
)
@click.version_option(__version__, '-v', '--version', help='Show the version and exit.')
def main(birthday, output):
    """
    \b
    Generate a life-in-weeks chart for a given BIRTHDAY.
    Birthday should be entered as YYYY-MM-DD.

    Example: lifeweeks 1980-02-14
    """
    validate_date(birthday)
    output_filename = process_filename(output)
    create_life_plot(birthday, output_filename)
    click.echo(f"Life-in-weeks chart saved to {output_filename}")
