% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/aqs_user.R
\name{create_user}
\alias{create_user}
\alias{aqs_signup}
\title{Create user-key object for accessing AQS API}
\usage{
create_user(email, key)

aqs_signup(email, ...)
}
\arguments{
\item{email}{Email address of user}

\item{key}{Key phrase of user}

\item{...}{Additional arguments passed to \code{\link{aqs_get}}}
}
\value{
\code{create_user} returns a list containing the email and key.
}
\description{
Create user-key object for accessing AQS API
}
\details{
The AQS API requires an email address and key for all queries. The key is not used for authentication (as in a password), but it is used for identification.

Once established, the email and key can be stored as environment variables as AQS_EMAIL and AQS_KEY, respectively.  Calling \code{create_user} without any argument will then read from these values. Care should still be taken to avoid storing the resulting object in a public repository.

Use \code{aqs_signup} to register an email and obtain a key phrase. The key value is emailed to the provided address, it is not return directly from the API.
}
\seealso{
\code{\link{aqs_get}}
}
