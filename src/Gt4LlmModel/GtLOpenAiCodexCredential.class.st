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

{ #category : #'as yet unclassified' }
GtLOpenAiCodexCredential class >> fromDefaultCodexFile [
	| json dict accessToken refreshToken accountId |
	json := FileLocator home / '.codex' / 'auth.json' contents.
	dict := STON fromString: json.
	accessToken := (dict at: 'tokens') at: 'access_token'.
	refreshToken := (dict at: 'tokens') at: 'refresh_token'.
	accountId := (dict at: 'tokens') at: 'account_id'.
	^ GtLOpenAiCodexCredential
		accessToken: accessToken
		refreshToken: refreshToken
		expiresAt: DateAndTime now + 1 hour
		accountId: accountId
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

{ #category : #accessing }
GtLOpenAiCodexCredential >> refreshToken [
	^ refreshToken
]

{ #category : #accessing }
GtLOpenAiCodexCredential >> refreshToken: aString [
	refreshToken := aString
]
