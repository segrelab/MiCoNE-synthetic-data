#!/usr/bin/env python3

import pathlib
from typing import List

import numpy as np
import pandas as pd


def change_md(file: pathlib.Path) -> None:
    """Change sample metadata md column value randomly
    Rewrite file in inplace
    """
    sample_md: pd.DataFrame = pd.read_table(file, index_col=0, sep="\t")
    sample_md.md = sample_md.md.map(lambda _: np.random.randint(1, 10))
    sample_md.index.name = "sample-id"
    sample_md.to_csv(file, index=True, sep="\t")


def main(files: List[pathlib.Path]) -> None:
    """Change sample metadata md column value randomly"""
    for file in files:
        change_md(file)


if __name__ == "__main__":
    FILES = list(pathlib.Path("../../data/").glob("**/sample_metadata.tsv"))
    main(FILES)
