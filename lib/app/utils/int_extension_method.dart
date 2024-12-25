extension IsHttpResponseSuccess on int {
  bool isHttpResponseSuccess() {
    return this >= 200 && this < 300;
  }

  bool isHttpResponseSuccessWithNoBody() {
    return this == 204;
  }

  bool isHttpResponseUnauthorized() {
    return this == 401;
  }

  bool isHttpResponseBadRequest() {
    return this == 400;
  }

  bool isHttpResponseInternalServerError() {
    return this >= 500;
  }

  bool isHttpResponseBadGateway() {
    return this == 503;
  }

  bool isHttpResponseForbidden() {
    return this == 403;
  }

  bool isHttpResponseNotFound() {
    return this == 404;
  }
}
