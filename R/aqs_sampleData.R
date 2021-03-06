##' @name aqs_sampleData
##' @title Extract data from the AQS API
##' @param aqs_user User credentials. See \code{\link{aqs_signup}}
##' @param endpoint Endpoint for selecting data. Required variables vary by endpoint.
##' @param param Parameter code for which to extract data. Up to five codes may included in a single request.
##' @param bdate Begin date for data sample interval. Should be a string in format "YYYYMMDD"
##' @param edate End date for data sample interval. Should be a string in format "YYYYMMDD". Must be from the same year as \code{edate}.
##' @param state Two-digit state code. Required when \code{endpoint} is one of \code{byState}, \code{byCounty}, \code{bySite}.
##' @param county Three-digit county code. Required when \code{endpoint} is \code{byCounty} or \code{bySite}.
##' @param site Three-digit site code. Required when \code{endpoint} is \code{bySite}.
##' @param cbdate Optional begin date for the date of last change interval. Should be a string in format "YYYYMMDD". If \code{cbdate} is provided, so much \code{cedate}.
##' @param cedate Optional end date for data of last change interval. Should be a string in format "YYYYMMDD". If \code{cedate} is provided, so much \code{cbdate}.
##' @param cbsa Three-digit census-bureau statistical area (CBSA) code. Required when \code{endpoint} is \code{byCBSA}.
##' @param minlat Minimum latitude for the bounding box. Required when \code{endpoint} is \code{byBox}.
##' @param maxlat Maximum latitude for the bounding box. Required when \code{endpoint} is \code{byBox}.
##' @param minlon Minimum longitude for the bounding box. Required when \code{endpoint} is \code{byBox}.
##' @param maxlon Maximum longitude for the bounding box. Required when \code{endpoint} is \code{byBox}.
##' @param ... Additional arguments passed to \code{\link{aqs_get}}
##' @details This queries the database using the "sampleData" endpoint. This will return any combination of measurements that meet the specified criteria. To query daily and annual summaries calculated by AQS, use \code{\link{aqs_dailyData}} and \code{\link{aqs_annualData}}.
##' @seealso \code{\link{aqs_get}}
##' @family Data Query Functions
##' @export
aqs_sampleData <- function(aqs_user,
                         endpoint=c("bySite",
                                    "byCounty",
                                    "byState",
                                    "byBox",
                                    "byCBSA"),
                         param,
                         bdate,
                         edate,
                         state=NULL,
                         county=NULL,
                         site=NULL,
                         cbdate=NULL,
                         cedate=NULL,
                        cbsa=NULL,
                        minlat=NULL,
                        maxlat=NULL,
                        minlon=NULL,
                        maxlon=NULL,
                         ...){

    if (checkDates(bdate)) stop("'bdate' must be a string of length 8 in the format YYYYMMDD.")
    if (checkDates(edate)) stop("'edate' must be a string of length 8 in the format YYYYMMDD.")
    if (as.Date(bdate, format="%Y%m%d") > as.Date(edate, format="%Y%m%d")){
        stop("'bdate' must be the same as or prior to 'edate'.")
    }
    if (substr(edate, 1, 4) != substr(bdate, 1, 4)){
        stop("'bdate' and 'edate' must be the same year.")
    }
    if (!is.null(cbdate) || !is.null(cedate)){
        if (is.null(cbdate) || is.null(cedate)) stop("If 'cbdate' or 'cedate' is provided, the other must also be provided.")
        if (checkDates(cbdate)) stop("'cbdate' must be a string of length 8 in the format YYYYMMDD.")
        if (checkDates(cedate)) stop("'cedate' must be a string of length 8 in the format YYYYMMDD.")
        if (as.Date(cbdate, format="%Y%m%d") > as.Date(cedate, format="%Y%m%d")){
            stop("'cbdate' must be the same as or prior to 'cedate'.")
        }
    }
    if (length(param)>5){
        stop("'param' is limited to 5 parameter codes in a single request.")
    }
    if (length(param)>1){
        param <- unique(param)
        param <- paste0(param, collapse=",")
    }
    vars <- list(param=param,
                 bdate=bdate,
                 edate=edate,
                 state=state,
                 county=county,
                 site=site,
                 cbdate=cbdate,
                 cedate=cedate,
                 cbsa=cbsa,
                 minlat=minlat,
                 maxlat=maxlat,
                 minlon=minlon,
                 maxlon=maxlon)
    # Only pass needed variables
    vars <- vars[names(vars) %in% c(list_required_vars(endpoint=endpoint), list_optional_vars(endpoint=endpoint))]
    out <- aqs_get(service="sampleData",
                   endpoint=endpoint,
                   aqs_user=aqs_user,
                   vars=vars,
                   ...)
    out
}

##' @rdname aqs_sampleData
##' @export
aqs_sampleData_bySite <- function(aqs_user,
                                  param,
                                  bdate,
                                  edate,
                                  state,
                                  county,
                                  site,
                                  ...){
    out <- aqs_sampleData(aqs_user=aqs_user,
                 endpoint="bySite",
                 param=param,
            bdate=bdate,
            edate=edate,
            state=state,
            county=county,
            site=site,
                 ...)
    out
}


##' @rdname aqs_sampleData
##' @export
aqs_sampleData_byCounty <- function(aqs_user,
                                    param,
                                    bdate,
                                    edate,
                                    state,
                                    county,
                                    ...){
    out <- aqs_sampleData(aqs_user=aqs_user,
                          endpoint="byCounty",
                          param=param,
                          bdate=bdate,
                          edate=edate,
                          state=state,
                          county=county,
                          ...)
    out
}

##' @rdname aqs_sampleData
##' @export
aqs_sampleData_byState <- function(aqs_user,
                                   param,
                                   bdate,
                                   edate,
                                   state,
                                   ...){
    out <- aqs_sampleData(aqs_user=aqs_user,
                          endpoint="byState",
                          param=param,
                          bdate=bdate,
                          edate=edate,
                          state=state,
                          ...)
    out
}

##' @rdname aqs_sampleData
##' @export
aqs_sampleData_byCBSA <- function(aqs_user,
                                   param,
                                   bdate,
                                   edate,
                                   cbsa,
                                   ...){
    out <- aqs_sampleData(aqs_user=aqs_user,
                          endpoint="byCBSA",
                          param=param,
                          bdate=bdate,
                          edate=edate,
                          cbsa=cbsa,
                          ...)
    out
}




##' @name aqs_annualData
##' @title Extract annual average data data from the AQS API
##' @inheritParams aqs_get
##' @inheritParams aqs_sampleData
##' @seealso \code{\link{aqs_get}}
##' @family Data Query Functions
##' @export
aqs_annualData <- function(aqs_user,
                           endpoint=c("bySite",
                                      "byCounty",
                                      "byState",
                                      "byBox",
                                      "byCBSA"),
                           param,
                           bdate,
                           edate,
                           state=NULL,
                           county=NULL,
                           site=NULL,
                           cbdate=NULL,
                           cedate=NULL,
                           cbsa=NULL,
                           minlat=NULL,
                           maxlat=NULL,
                           minlon=NULL,
                           maxlon=NULL,
                           ...){
    if (checkDates(bdate)) stop("'bdate' must be a string of length 8 in the format YYYYMMDD.")
    if (checkDates(edate)) stop("'edate' must be a string of length 8 in the format YYYYMMDD.")
    if (as.Date(bdate, format="%Y%m%d") > as.Date(edate, format="%Y%m%d")){
        stop("'bdate' must be the same as or prior to 'edate'.")
    }
    if (substr(edate, 1, 4) != substr(bdate, 1, 4)){
        stop("'bdate' and 'edate' must be the same year.")
    }
    if (!is.null(cbdate) || !is.null(cedate)){
        if (is.null(cbdate) || is.null(cedate)) stop("If 'cbdate' or 'cedate' is provided, the other must also be provided.")
        if (checkDates(cbdate)) stop("'cbdate' must be a string of length 8 in the format YYYYMMDD.")
        if (checkDates(cedate)) stop("'cedate' must be a string of length 8 in the format YYYYMMDD.")
        if (as.Date(cbdate, format="%Y%m%d") > as.Date(cedate, format="%Y%m%d")){
            stop("'cbdate' must be the same as or prior to 'cedate'.")
        }
    }
    if (length(param)>5){
        stop("'param' is limited to 5 parameter codes in a single request.")
    }
    if (length(param)>1){
        param <- unique(param)
        param <- paste0(param, collapse=",")
    }
    vars <- list(param=param,
                 bdate=bdate,
                 edate=edate,
                 state=state,
                 county=county,
                 site=site,
                 cbdate=cbdate,
                 cedate=cedate,
                 cbsa=cbsa,
                 minlat=minlat,
                 maxlat=maxlat,
                 minlon=minlon,
                 maxlon=maxlon)
    # Only pass needed variables
    vars <- vars[names(vars) %in% c(list_required_vars(endpoint=endpoint), list_optional_vars(endpoint=endpoint))]
    out <- aqs_get(service="annualData",
                   endpoint=endpoint,
                   aqs_user=aqs_user,
                   vars=vars,
                   ...)
    out
}

##' @rdname aqs_annualData
##' @export
aqs_annualData_bySite <- function(aqs_user,
                                  param,
                                  bdate,
                                  edate,
                                  state,
                                  county,
                                  site,
                                  ...){
    out <- aqs_annualData(aqs_user=aqs_user,
                          endpoint="bySite",
                          param=param,
                          bdate=bdate,
                          edate=edate,
                          state=state,
                          county=county,
                          site=site,
                          ...)
    out
}


##' @rdname aqs_annualData
##' @export
aqs_annualData_byCounty <- function(aqs_user,
                                    param,
                                    bdate,
                                    edate,
                                    state,
                                    county,
                                    ...){
    out <- aqs_annualData(aqs_user=aqs_user,
                          endpoint="byCounty",
                          param=param,
                          bdate=bdate,
                          edate=edate,
                          state=state,
                          county=county,
                          ...)
    out
}

##' @rdname aqs_annualData
##' @export
aqs_annualData_byState <- function(aqs_user,
                                   param,
                                   bdate,
                                   edate,
                                   state,
                                   ...){
    out <- aqs_annualData(aqs_user=aqs_user,
                          endpoint="byState",
                          param=param,
                          bdate=bdate,
                          edate=edate,
                          state=state,
                          ...)
    out
}

##' @rdname aqs_annualData
##' @export
aqs_annualData_byCBSA <- function(aqs_user,
                                  param,
                                  bdate,
                                  edate,
                                  cbsa,
                                  ...){
    out <- aqs_annualData(aqs_user=aqs_user,
                          endpoint="byCBSA",
                          param=param,
                          bdate=bdate,
                          edate=edate,
                          cbsa=cbsa,
                          ...)
    out
}



##' @name aqs_dailyData
##' @title Extract daily average data data from the AQS API
##' @inheritParams aqs_get
##' @inheritParams aqs_sampleData
##' @seealso \code{\link{aqs_get}}
##' @family Data Query Functions
##' @export
aqs_dailyData <- function(aqs_user,
                           endpoint=c("bySite",
                                      "byCounty",
                                      "byState",
                                      "byBox",
                                      "byCBSA"),
                           param,
                           bdate,
                           edate,
                           state=NULL,
                           county=NULL,
                           site=NULL,
                           cbdate=NULL,
                           cedate=NULL,
                           cbsa=NULL,
                           minlat=NULL,
                           maxlat=NULL,
                           minlon=NULL,
                           maxlon=NULL,
                           ...){
    if (checkDates(bdate)) stop("'bdate' must be a string of length 8 in the format YYYYMMDD.")
    if (checkDates(edate)) stop("'edate' must be a string of length 8 in the format YYYYMMDD.")
    if (as.Date(bdate, format="%Y%m%d") > as.Date(edate, format="%Y%m%d")){
        stop("'bdate' must be the same as or prior to 'edate'.")
    }
    if (substr(edate, 1, 4) != substr(bdate, 1, 4)){
        stop("'bdate' and 'edate' must be the same year.")
    }
    if (!is.null(cbdate) || !is.null(cedate)){
        if (is.null(cbdate) || is.null(cedate)) stop("If 'cbdate' or 'cedate' is provided, the other must also be provided.")
        if (checkDates(cbdate)) stop("'cbdate' must be a string of length 8 in the format YYYYMMDD.")
        if (checkDates(cedate)) stop("'cedate' must be a string of length 8 in the format YYYYMMDD.")
        if (as.Date(cbdate, format="%Y%m%d") > as.Date(cedate, format="%Y%m%d")){
            stop("'cbdate' must be the same as or prior to 'cedate'.")
        }
    }
    if (length(param)>5){
        stop("'param' is limited to 5 parameter codes in a single request.")
    }
    if (length(param)>1){
        param <- unique(param)
        param <- paste0(param, collapse=",")
    }
    vars <- list(param=param,
                 bdate=bdate,
                 edate=edate,
                 state=state,
                 county=county,
                 site=site,
                 cbdate=cbdate,
                 cedate=cedate,
                 cbsa=cbsa,
                 minlat=minlat,
                 maxlat=maxlat,
                 minlon=minlon,
                 maxlon=maxlon)
    # Only pass needed variables
    vars <- vars[names(vars) %in% c(list_required_vars(endpoint=endpoint), list_optional_vars(endpoint=endpoint))]
    out <- aqs_get(service="dailyData",
                   endpoint=endpoint,
                   aqs_user=aqs_user,
                   vars=vars,
                   ...)
    out
}

##' @rdname aqs_dailyData
##' @export
aqs_dailyData_bySite <- function(aqs_user,
                                  param,
                                  bdate,
                                  edate,
                                  state,
                                  county,
                                  site,
                                  ...){
    out <- aqs_dailyData(aqs_user=aqs_user,
                          endpoint="bySite",
                          param=param,
                          bdate=bdate,
                          edate=edate,
                          state=state,
                          county=county,
                          site=site,
                          ...)
    out
}


##' @rdname aqs_dailyData
##' @export
aqs_dailyData_byCounty <- function(aqs_user,
                                    param,
                                    bdate,
                                    edate,
                                    state,
                                    county,
                                    ...){
    out <- aqs_dailyData(aqs_user=aqs_user,
                          endpoint="byCounty",
                          param=param,
                          bdate=bdate,
                          edate=edate,
                          state=state,
                          county=county,
                          ...)
    out
}

##' @rdname aqs_dailyData
##' @export
aqs_dailyData_byState <- function(aqs_user,
                                   param,
                                   bdate,
                                   edate,
                                   state,
                                   ...){
    out <- aqs_dailyData(aqs_user=aqs_user,
                          endpoint="byState",
                          param=param,
                          bdate=bdate,
                          edate=edate,
                          state=state,
                          ...)
    out
}

##' @rdname aqs_dailyData
##' @export
aqs_dailyData_byCBSA <- function(aqs_user,
                                  param,
                                  bdate,
                                  edate,
                                  cbsa,
                                  ...){
    out <- aqs_dailyData(aqs_user=aqs_user,
                          endpoint="byCBSA",
                          param=param,
                          bdate=bdate,
                          edate=edate,
                          cbsa=cbsa,
                          ...)
    out
}

##' @importFrom methods is
checkDates <- function(date){
    flag <- 0
    if (nchar(date)!=8 | !methods::is(date, "character")){
        flag <- 1
    } else if (is.na(suppressWarnings(as.Date(date, format="%Y%m%d")))){
        flag <- 1
    }
    flag
}
