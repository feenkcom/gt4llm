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
