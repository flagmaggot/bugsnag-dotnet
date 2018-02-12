using System;
using System.Linq;
using System.Collections.Generic;
using System.Web;

namespace Bugsnag.AspNet
{
  public class Request : Payload.IHttpRequest
  {
    private readonly string _clientIp;
    private readonly IDictionary<string, string> _headers;
    private readonly string _httpMethod;
    private readonly string _url;
    private readonly string _referer;

    public Request(HttpContextBase httpContext)
    {
      _clientIp = httpContext.Request.UserHostAddress;
      _headers = httpContext.Request.Headers.AllKeys.ToDictionary(k => k, k => httpContext.Request.Headers[k]);
      _httpMethod = httpContext.Request.HttpMethod;
      _url = httpContext.Request.Url.ToString();
      _referer = httpContext.Request.UrlReferrer.ToString();
    }

    public string ClientIp => _clientIp;

    public IDictionary<string, string> Headers => _headers;

    public string HttpMethod => _httpMethod;

    public string Url => _url;

    public string Referer => _referer;
  }
}
