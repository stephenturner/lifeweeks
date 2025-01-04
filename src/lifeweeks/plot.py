import matplotlib.pyplot as plt
import datetime


def create_life_plot(birthday, output_filename):
    # Calculate weeks lived and total weeks
    today = datetime.date.today()
    birth_date = datetime.datetime.strptime(birthday, "%Y-%m-%d").date()
    days_lived = (today - birth_date).days
    years_lived = days_lived / 365.25
    weeks_lived = round(years_lived * 52)
    total_weeks = 52 * 90  # Assuming a lifespan of 90 years

    # Generate the data
    lived = [True] * weeks_lived + [False] * (total_weeks - weeks_lived)
    rows, cols = 90, 52
    grid = [
        [
            lived[row * cols + col] if row * cols + col < len(lived) else False
            for col in range(cols)
        ]
        for row in range(rows)
    ]

    # Plot the data
    fig, ax = plt.subplots(figsize=(8.5, 11))
    block_size = 0.75  # Smaller blocks for more whitespace
    stroke_width = 0.3  # Reduced stroke width for blocks
    for y, row in enumerate(grid):
        for x, lived in enumerate(row):
            color = (
                str(0.3) if lived else "white"
            )  # Use grayscale value for lived weeks
            rect = plt.Rectangle(
                (x, -y),
                block_size,
                block_size,
                facecolor=color,
                edgecolor="black",
                linewidth=stroke_width,
            )
            ax.add_patch(rect)

    # Add axes
    ax.set_xlim(0, cols)
    ax.set_ylim(-rows, 0)
    ax.set_aspect("equal", "box")
    ax.set_xticks(range(0, cols + 1, 10))  # Major ticks every 10 weeks
    ax.set_yticks(range(0, -rows - 1, -10))  # Major ticks every 10 years
    ax.set_xticklabels(range(0, cols + 1, 10), fontsize=8)
    ax.set_yticklabels([abs(y) for y in range(0, -rows - 1, -10)], fontsize=8)

    # Style the axes
    ax.spines["top"].set_visible(False)
    ax.spines["right"].set_visible(False)
    ax.spines["bottom"].set_visible(False)
    ax.spines["left"].set_visible(False)
    ax.tick_params(
        axis="x",
        bottom=False,
        labeltop=True,
        labelbottom=False,
        direction="out",
        length=0,
    )  # Labels at the top
    ax.tick_params(axis="y", left=False, direction="out", length=0)

    # Title and labels
    ax.set_title("Your Life in Weeks", fontsize=16)
    ax.set_xlabel("Weeks in a Year", fontsize=12, labelpad=10)
    ax.set_ylabel("Age (Years)", fontsize=12, labelpad=10)

    # Save to PDF
    plt.savefig(output_filename, format="pdf", bbox_inches="tight")
    plt.close()
