Class {
	#name : #GtOpenAIUploadFileAPIClient,
	#superclass : #GtLlmEndpointClient,
	#instVars : [
		'file',
		'purpose'
	],
	#category : #'Gt4OpenAI-Client'
}

{ #category : #accessing }
GtOpenAIUploadFileAPIClient >> file [
	^ file
]

{ #category : #accessing }
GtOpenAIUploadFileAPIClient >> file: anObject [
	file := anObject
]

{ #category : #accessing }
GtOpenAIUploadFileAPIClient >> purpose [
	^ purpose
]

{ #category : #accessing }
GtOpenAIUploadFileAPIClient >> purpose: anObject [
	purpose := anObject
]

{ #category : #accessing }
GtOpenAIUploadFileAPIClient >> request [
	^ self client
		postFile: '/files'
		withEntity: (ZnMultiPartFormDataEntity new
				addPart: (ZnMimePart fieldName: 'purpose' value: self purpose);
				addPart: (ZnMimePart
						fieldName: 'file'
						fileName: self file basename
						entity: (ZnEntity bytes: self file binaryContents));
				yourself)
]

{ #category : #accessing }
GtOpenAIUploadFileAPIClient >> serializationClass [
	^ GtOpenAIFile
]
