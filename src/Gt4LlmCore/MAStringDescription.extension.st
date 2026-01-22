Extension { #name : #MAStringDescription }

{ #category : #'*Gt4LlmCore' }
MAStringDescription >> withUUIDBase64FormatComment [
	self withUUIDBase64FormatCommentWith: ''
]

{ #category : #'*Gt4LlmCore' }
MAStringDescription >> withUUIDBase64FormatCommentWith: aPrefix [ 
	self comment:(aPrefix
		ifEmpty: [ aPrefix]
		ifNotEmpty: [ 
				| trimmedPrefix |
				trimmedPrefix := aPrefix trimRight.
				(trimmedPrefix endsWith: '.')
					ifTrue: [ trimmedPrefix, ' ']
					ifFalse: [ trimmedPrefix, '. ']]), ' An RFC4122 Universally Unique Identifier (UUID). Its format should be a String in Base64 encoding. Base64 is a technique to encode binary data as a string of characters that can be safely transported over various protocols. Basically, every 3 bytes are encoded using 4 characters from an alphabet of 64. Each encoded character represents 6 bits.'
]

{ #category : #'*Gt4LlmCore' }
MAStringDescription >> withUUIDFormatComment [
	self withUUIDFormatCommentWith:''
]

{ #category : #'*Gt4LlmCore' }
MAStringDescription >> withUUIDFormatCommentWith: aPrefix [
	self comment:(aPrefix
		ifEmpty: [ aPrefix]
		ifNotEmpty: [ 
				| trimmedPrefix |
				trimmedPrefix := aPrefix trimRight.
				(trimmedPrefix endsWith: '.')
					ifTrue: [ trimmedPrefix, ' ']
					ifFalse: [ trimmedPrefix, '. ']]), 'An RFC4122 Universally Unique Identifier (UUID). Its format is a String with its official representation, 32 lowercase hexadecimal digits, displayed in five groups separated by hyphens, in the form 8-4-4-4-12 for a total of 36 characters (32 alphanumeric characters and four hyphens)'
]
