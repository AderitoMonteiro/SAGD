from .audit import reset_audit_request, set_audit_request


class AuditRequestMiddleware:
    def __init__(self, get_response):
        self.get_response = get_response

    def __call__(self, request):
        token = set_audit_request(request)
        try:
            return self.get_response(request)
        finally:
            reset_audit_request(token)
