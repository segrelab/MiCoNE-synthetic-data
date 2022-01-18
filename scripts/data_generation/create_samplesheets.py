#!/usr/bin/env python3

import pathlib
from typing import List

import pandas as pd

HEADER = ["id", "otu_table", "obs_metadata", "sample_metadata", "children_map"]


def main(files: List[pathlib.Path], name: str) -> None:
    """Create samplesheet for list of files"""
    data = []
    for file in files:
        dir = file.parent
        id_ = dir.stem
        otu_table = dir / "otu_table.tsv"
        obs_metadata = dir / "obs_metadata.tsv"
        sample_metadata = dir / "sample_metadata.tsv"
        children_map = dir / "children_map.json"
        data.append(
            {
                "id": id_,
                "otu_table": otu_table,
                "obs_metadata": obs_metadata,
                "sample_metadata": sample_metadata,
                "children_map": children_map,
            }
        )
    df = pd.DataFrame(data, columns=HEADER)
    cwd = pathlib.Path(f"../../pipeline/{name}")
    df.to_csv(cwd / "samplesheet.csv", index=False, sep=",")


if __name__ == "__main__":
    NORTA_FILES = list(pathlib.Path("../../data/norta/").glob("**/otu_table.tsv"))
    SEQTIME_FILES = list(pathlib.Path("../../data/seqtime/").glob("**/otu_table.tsv"))
    main(NORTA_FILES, "norta")
    main(SEQTIME_FILES, "seqtime")
