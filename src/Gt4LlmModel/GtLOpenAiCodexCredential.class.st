Class {
	#name : #GtLOpenAiCodexCredential,
	#superclass : #Object,
	#instVars : [
		'accessToken',
		'refreshToken',
		'expiresAt',
		'accountId'
	],
	#category : #'Gt4LlmModel-Codex'
}

{ #category : #'instance creation' }
GtLOpenAiCodexCredential class >> accessToken: anAccessToken refreshToken: aRefreshToken expiresAt: anExpiry accountId: anAccountId [
	^ self new
		accessToken: anAccessToken;
		refreshToken: aRefreshToken;
		expiresAt: anExpiry;
		accountId: anAccountId;
		yourself
]

{ #category : #'instance creation' }
GtLOpenAiCodexCredential class >> expiresAtFromAccessToken: anAccessToken [
	| parts encodedPayload paddingCount payload expiresAtSeconds |
	[ | paddedPayload |
	parts := anAccessToken substrings: '.'.
	parts size < 2 ifTrue: [ ^ nil ].
	encodedPayload := parts second.
	paddingCount := (4 - (encodedPayload size \\ 4)) \\ 4.
	paddedPayload := encodedPayload , (String new: paddingCount withAll: $=).
	payload := NeoJSONReader fromString: (Base64UrlEncoder new decode: paddedPayload) utf8Decoded.
	expiresAtSeconds := payload at: 'exp' ifAbsent: [ ^ nil ].
	^ DateAndTime fromUnixTime: expiresAtSeconds ]
		on: Error
		do: [ :error | nil ]
]

{ #category : #'instance creation' }
GtLOpenAiCodexCredential class >> fromDefaultCodexFile [
	| json dict accessToken refreshToken accountId expiry |
	json := FileLocator home / '.codex' / 'auth.json' contents.
	dict := STON fromString: json.
	accessToken := (dict at: 'tokens') at: 'access_token'.
	refreshToken := (dict at: 'tokens') at: 'refresh_token'.
	accountId := (dict at: 'tokens') at: 'account_id'.
	expiry := self expiresAtFromAccessToken: accessToken.
	^ self
		accessToken: accessToken
		refreshToken: refreshToken
		expiresAt: expiry
		accountId: accountId
]

{ #category : #private }
GtLOpenAiCodexCredential class >> responseStringFrom: aResponseBody [
	aResponseBody isString ifTrue: [ ^ aResponseBody ].
	(aResponseBody isKindOf: ByteArray) ifTrue: [ ^ aResponseBody utf8Decoded ].
	(aResponseBody respondsTo: #upToEnd) ifTrue:
		[ ^ self responseStringFrom: aResponseBody upToEnd ].
	self error: 'Unexpected OAuth response body: ', aResponseBody class name
]

{ #category : #accessing }
GtLOpenAiCodexCredential >> accessToken [
	^ accessToken
]

{ #category : #accessing }
GtLOpenAiCodexCredential >> accessToken: aString [
	accessToken := aString
]

{ #category : #accessing }
GtLOpenAiCodexCredential >> accountId [
	^ accountId
]

{ #category : #accessing }
GtLOpenAiCodexCredential >> accountId: aString [
	accountId := aString
]

{ #category : #accessing }
GtLOpenAiCodexCredential >> expiresAt [
	^ expiresAt
]

{ #category : #accessing }
GtLOpenAiCodexCredential >> expiresAt: aDateAndTime [
	expiresAt := aDateAndTime
]

{ #category : #testing }
GtLOpenAiCodexCredential >> isExpired [
	^ expiresAt notNil and: [ expiresAt <= DateAndTime now ]
]

{ #category : #oauth }
GtLOpenAiCodexCredential >> refresh [
	| http form responseBody responseJson expiresIn |
	refreshToken ifNil: [ self error: 'No ChatGPT Codex refresh token is configured' ].
	form := 'grant_type=refresh_token&refresh_token=',
		(ZnPercentEncoder new encode: refreshToken),
		'&client_id=app_EMoamEEZ73f0CkXaXp7hrann'.
	http := ZnClient new.
	http url: 'https://auth.openai.com/oauth/token' asZnUrl.
	http entity: (ZnEntity with: form type: ZnMimeType applicationFormUrlEncoded).
	responseBody := http post.
	responseJson := NeoJSONReader fromString: (self class responseStringFrom: responseBody).
	accessToken := responseJson
		at: 'access_token'
		ifAbsent: [ self error: 'Codex OAuth refresh response has no access_token' ].
	refreshToken := responseJson at: 'refresh_token' ifAbsent: [ refreshToken ].
	expiresIn := responseJson
		at: 'expires_in'
		ifAbsent: [ self error: 'Codex OAuth refresh response has no expires_in' ].
	^ self class
		accessToken: accessToken
		refreshToken: refreshToken
		expiresAt: DateAndTime now + expiresIn asInteger seconds
		accountId: accountId
]

{ #category : #accessing }
GtLOpenAiCodexCredential >> refreshToken [
	^ refreshToken
]

{ #category : #accessing }
GtLOpenAiCodexCredential >> refreshToken: aString [
	refreshToken := aString
]
