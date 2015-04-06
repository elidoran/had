# had

Result/Error holder and helper

Avoid throw/catching errors by return results in a 'had' object. Then, when
errors occur, they can be placed in the `had` object. All the code using the
`had` for its results should check if there's an error and do something different.

This encourages the programmer to describe the error and provide details from
the context where the error occurred.

It avoids Errors traveling way up to a catch when it could have been handled
before there.

`had.result` is where results are placed.

`had.error` is where the errors are placed. 
