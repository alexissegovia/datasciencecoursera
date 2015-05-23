## Put comments here that give an overall description of what your
## functions do

## Write a short comment describing this function
# makeCacheMatrix creates a list containing a function to
# 1. set the value of the matrix
# 2. get the value of the matrix
# 3. set the value of inverse of the matrix
# 4. get the value of inverse of the matrix
makeCacheMatrix <- function(x = matrix()) {
    invMatrix <- NULL
    set <- function(y) {
        x <<- y
        invMatrix <<- NULL
    }
    get <- function() x
    setinverse <- function(inverse) invMatrix <<- inverse
    getinverse <- function() invMatrix
    list(set=set, get=get, setinverse=setinverse, getinverse=getinverse)
}
## Write a short comment describing this function
# The following function returns the inverse of the matrix.
# For this assignment, assume that the matrix supplied is always invertible.
cacheSolve <- function(x, ...) {
        ## Return a matrix that is the inverse of 'x'
    invMatrix <- x$getinverse()
    if(!is.null(invMatrix)) {
        message("getting cached data")
        return(invMatrix)
    }
    datos <- x$get()
    invMatrix <- solve(datos)
    x$setinverse(invMatrix)
    invMatrix
}
