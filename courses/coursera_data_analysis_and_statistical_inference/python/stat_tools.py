import pandas
from pandas import DataFrame

def two_column_summary(df, index, column, do_totals=True, do_prob=False):
    """returns a DataFrame contingency (frequency) summary table for two columns.

    arguments:
    df       -- input DataFrame
    index    -- the column used to summarize vertically
    column   -- the column used to summarize vertically
    to_total -- places a row and column to summarize the total along that axis
    do_prob  -- instead of return frequency, return probablity
    """

    # test input
    if not (column in df.columns):
        raise ValueError("[two_column_summary] '%s' no a valid column name" % column)
    if not (index in df.columns):
        raise ValueError("[two_column_summary] '%s' no a valid column name" % index)

    # group for each column
    unique_col_values = df[column].unique()
    cols = []
    for v in unique_col_values:
        mask = df[column]==v
        cols.append(df[mask].groupby(index))

    # glue groups back together
    df_summary = DataFrame()
    for idx, c in enumerate(cols):
        d = c.count()
        d.columns = [unique_col_values[idx]]
        df_summary = pandas.concat([df_summary, d], axis=1)

    # add total
    if do_totals:
        df_summary['total']    = df_summary.apply(sum, axis=1)
        df_summary.ix['total'] = df_summary.sum()

    # make into probablity
    if do_prob:
        df_summary = df_summary/df_summary.ix['total']['total']

    return df_summary
