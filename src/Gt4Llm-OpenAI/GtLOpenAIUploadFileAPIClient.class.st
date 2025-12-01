Class {
	#name : #GtLOpenAIUploadFileAPIClient,
	#superclass : #GtLAPICommand,
	#instVars : [
		'file',
		'purpose'
	],
	#category : #'Gt4Llm-OpenAI'
}

{ #category : #accessing }
GtLOpenAIUploadFileAPIClient >> file [
	^ file
]

{ #category : #accessing }
GtLOpenAIUploadFileAPIClient >> file: anObject [
	file := anObject
]

{ #category : #accessing }
GtLOpenAIUploadFileAPIClient >> fileToEntity [
	| extension mimeType |
	(self file isKindOf: GtLlmFineTuningFile)
		ifTrue: [ ^ ZnEntity with: self file contents type: 'application/jsonl' ].

	extension := self file extension ifNil: ''.
	mimeType := ({'png' -> 'image/png'.
			'jpg' -> 'image/jpeg'.
			'jpeg' -> 'image/jpeg'.
			'gif' -> 'image/gif'.
			'txt' -> 'text/plain'.
			'csv' -> 'text/csv'.
			'json' -> 'application/json'} asDictionary
			at: extension asLowercase
			ifAbsent: [ 'application/octet-stream' ]) asZnMimeType.

	^ (ZnEntity bytes: self file binaryContents) contentType: mimeType
]

{ #category : #accessing }
GtLOpenAIUploadFileAPIClient >> purpose [
	^ purpose
]

{ #category : #accessing }
GtLOpenAIUploadFileAPIClient >> purpose: anObject [
	purpose := anObject
]

{ #category : #actions }
GtLOpenAIUploadFileAPIClient >> request [
	^ self client
		postFile: '/files'
		withEntity: (ZnMultiPartFormDataEntity new
				addPart: (ZnMimePart fieldName: 'purpose' value: self purpose);
				addPart: (ZnMimePart
						fieldName: 'file'
						fileName: self file basename
						entity: self fileToEntity);
				yourself)
]

{ #category : #accessing }
GtLOpenAIUploadFileAPIClient >> serializationClass [
	^ GtLOpenAIFile
]
