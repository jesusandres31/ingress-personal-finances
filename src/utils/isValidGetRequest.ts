const isValidGetRequest = (
  offset: any,
  limit: any,
  filter: any,
  sort_column: any,
  sort_direction: any,
) => {
  if (
    typeof offset === 'number' &&
    typeof limit === 'number' &&
    typeof filter === 'string' &&
    typeof sort_column === 'string' &&
    typeof sort_direction === 'string'
  ) {
    return true;
  }
  return false;
};
