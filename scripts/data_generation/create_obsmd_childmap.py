#!/usr/bin/env python3

import json
import pathlib
from typing import List

import pandas as pd

MD_COLUMNS = ("Kingdom", "Phylum", "Class", "Order", "Family", "Genus", "Species")


def create_obs_metadata(otu: pd.DataFrame) -> pd.DataFrame:
    """Create a filler obs_metadata file"""
    index = otu.index
    columns = MD_COLUMNS
    obs_md_data = [{col: f"{col}_{i}" for col in columns} for i in index]
    obs_md = pd.DataFrame(obs_md_data, index=index, columns=columns)
    return obs_md


def create_children_map(otu: pd.DataFrame) -> dict:
    """Create an empty json file for the children map"""
    return dict()


def main(otu_files: List[pathlib.Path]) -> None:
    """Create obs_metadata and children_map files"""
    for otu_file in otu_files:
        dir = otu_file.parent
        otu: pd.DataFrame = pd.read_table(otu_file, index_col=0, sep="\t")
        obs_metadata = create_obs_metadata(otu)
        obs_metadata_file = dir / "obs_metadata.tsv"
        obs_metadata.to_csv(obs_metadata_file, index=True, sep="\t")
        children_map = create_children_map(otu)
        children_map_file = dir / "children_map.json"
        with open(children_map_file, "w") as fid:
            json.dump(children_map, fid)


if __name__ == "__main__":
    OTU_FILES = list(pathlib.Path("../../data/").glob("**/otu_table.tsv"))
    main(OTU_FILES)
