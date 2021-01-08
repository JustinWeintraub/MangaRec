List<dynamic> listWrapper(data, child, [onChange, parameters]) {
  List<dynamic> res = [];

  for (int i = 0; i < data.length; i++) {
    if (onChange != null) {
      if (parameters is Map)
        res.add(child(data[i], onChange, parameters[data[i]]));
      else
        res.add(child(data[i], onChange, parameters[i]));
    } else
      res.add(child(data[i]));
  }
  return res;
}
