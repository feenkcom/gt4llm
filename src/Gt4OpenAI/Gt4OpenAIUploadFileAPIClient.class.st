Class {
	#name : #Gt4OpenAIUploadFileAPIClient,
	#superclass : #Gt4OpenAIEndpointClient,
	#instVars : [
		'file',
		'purpose'
	],
	#category : #'Gt4OpenAI-Client'
}

{ #category : #accessing }
Gt4OpenAIUploadFileAPIClient >> file [
	^ file
]

{ #category : #accessing }
Gt4OpenAIUploadFileAPIClient >> file: anObject [
	file := anObject
]

{ #category : #accessing }
Gt4OpenAIUploadFileAPIClient >> purpose [
	^ purpose
]

{ #category : #accessing }
Gt4OpenAIUploadFileAPIClient >> purpose: anObject [
	purpose := anObject
]

{ #category : #accessing }
Gt4OpenAIUploadFileAPIClient >> request [
	^ self client
		postFile: '/files'
		withEntity: (ZnMultiPartFormDataEntity new
				addPart: (ZnMimePart fieldName: 'purpose' value: self purpose);
				addPart: (ZnMimePart
						fieldName: 'file'
						fileName: self file basename
						entity: (ZnEntity text: self file contents));
				yourself)
]

{ #category : #accessing }
Gt4OpenAIUploadFileAPIClient >> serializationClass [
	^ Gt4OpenAIFile
]
