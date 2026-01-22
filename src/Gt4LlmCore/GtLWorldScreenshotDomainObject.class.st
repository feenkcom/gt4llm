Class {
	#name : #GtLWorldScreenshotDomainObject,
	#superclass : #GtLDomainObject,
	#instVars : [
		'fileName',
		'data'
	],
	#category : #Gt4LlmCore
}

{ #category : #accessing }
GtLWorldScreenshotDomainObject >> contentType [
	^ 'image/png'
]

{ #category : #accessing }
GtLWorldScreenshotDomainObject >> data [
	^ data
]

{ #category : #accessing }
GtLWorldScreenshotDomainObject >> data: aByteArray [
	data := aByteArray
		ifNil: [ self error: 'data cannot be nil' ]
		ifNotNil: [ aByteArray asByteArray ]
]

{ #category : #accessing }
GtLWorldScreenshotDomainObject >> fileName [
	^ fileName
]

{ #category : #accessing }
GtLWorldScreenshotDomainObject >> fileName: aString [
	fileName := aString
		ifNil: [ self error: 'fileName cannot be nil' ]
		ifNotNil: [ aString asString ]
]

{ #category : #serialization }
GtLWorldScreenshotDomainObject >> serializeToOpenAIResponseJsonObject [
	| encoder |
	encoder := ZnBase64Encoder new.
	^ NeoJSONObject new
		at: #fileName put: self fileName;
		at: #contentType put: self contentType;
		at: #data put: (encoder encode: self data);
		yourself
]
