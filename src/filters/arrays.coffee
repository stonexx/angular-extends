'use strict'

angular.module 'ngExtends.filters.arrays', []

.filter 'makeArray', [-> (input) -> if angular.isArray input then input else $.makeArray(input)]

.filter 'range', [-> (from, to, step = 1) ->
  isNumber = typeof from is 'number' and typeof to is 'number'
  begin = if isNumber then from else from.toString().charCodeAt(0)
  end = if isNumber then to else to.toString().charCodeAt(0)
  for i in [begin..end] by (if begin > end then -step else step)
    if isNumber then i else String.fromCharCode(i)
]

.filter 'join', [-> (input, sep) -> $.makeArray(input).join(sep)]

.filter 'combine', [-> (input, transformers...) ->
  input = [input]  unless angular.isArray input
  (for value in input
    for t in transformers
      if angular.isFunction t
        value = t(value)
      else if typeof t is 'string'
        value = switch t
          when '=integer' then parseInt(value)
          when '=float'   then parseFloat(value)
          else $.obj.get(value, t)
    value
  ).reduce (t, v) -> t + v
]

.filter 'limit', [-> (input, page, itemsPerPage) ->
  from = (page - 1) * itemsPerPage
  to = from + itemsPerPage
  $.makeArray(input)[from...to]
]

.filter 'trim', [-> (input) ->
  if angular.isArray input
    a?.toString?()?.trim?()  for a in input
  else
    input?.toString?()?.trim?()
]