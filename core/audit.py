from contextvars import ContextVar


_request_context = ContextVar('audit_request_context', default=None)


def set_audit_request(request):
    return _request_context.set(request)


def reset_audit_request(token):
    _request_context.reset(token)


def get_audit_request():
    return _request_context.get()


def request_metadata(request=None):
    request = request or get_audit_request()
    if not request:
        return {}
    forwarded = request.META.get('HTTP_X_FORWARDED_FOR', '')
    ip_address = forwarded.split(',')[0].strip() if forwarded else request.META.get('REMOTE_ADDR')
    user = getattr(request, 'user', None)
    return {
        'utilizador': user if getattr(user, 'is_authenticated', False) else None,
        'endereco_ip': ip_address or None,
        'user_agent': request.META.get('HTTP_USER_AGENT', '')[:2000],
        'rota': (getattr(request, 'path', '') or '')[:255],
        'metodo_http': (getattr(request, 'method', '') or '')[:10],
    }
