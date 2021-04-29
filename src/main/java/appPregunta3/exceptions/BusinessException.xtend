package appPregunta3.exceptions

import org.springframework.web.bind.annotation.ResponseStatus

@ResponseStatus(BAD_REQUEST)
class BusinessException extends RuntimeException {
	new(String messagge) {
		super(messagge)
	}
}
