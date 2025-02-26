Class {
	#name : #GtOpenAIFile,
	#superclass : #GtLlmEntity,
	#instVars : [
		'id',
		'purpose',
		'filename',
		'bytes',
		'createdAt',
		'status',
		'statusDetails'
	],
	#category : #Gt4OpenAI
}

{ #category : #accessing }
GtOpenAIFile class >> serializationProperties [
	^ {#id -> #id.
		#purpose -> #purpose.
		#filename -> #filename.
		#bytes -> #bytes.
		#created_at -> #createdAt.
		#status -> #status.
		#status_details -> #statusDetails}
]

{ #category : #accessing }
GtOpenAIFile >> bytes [
	^ bytes
]

{ #category : #accessing }
GtOpenAIFile >> bytes: anObject [
	bytes := anObject
]

{ #category : #'as yet unclassified' }
GtOpenAIFile >> contents [
	^ (FileSystem memory / self filename) ensureCreateFile
		binaryWriteStreamDo: [ :aStream | aStream nextPutAll: (self client getFileContents: self id) ];
		yourself
]

{ #category : #accessing }
GtOpenAIFile >> createdAt [
	^ createdAt
]

{ #category : #accessing }
GtOpenAIFile >> createdAt: anObject [
	createdAt := self deserializeTime: anObject
]

{ #category : #accessing }
GtOpenAIFile >> filename [
	^ filename
]

{ #category : #accessing }
GtOpenAIFile >> filename: anObject [
	filename := anObject
]

{ #category : #'as yet unclassified' }
GtOpenAIFile >> gtFileFor: aView [
	<gtView>
	^ aView explicit
		title: 'File';
		priority: 1;
		stencil: [ (self contents gtViewsFor: GtPhlowEmptyView new)
				asElementDo: [ :e | 
					e
						margin: (BlInsets all: 15);
						background: Color white;
						addAptitude: BrShadowAptitude ] ]
]

{ #category : #accessing }
GtOpenAIFile >> id [
	^ id
]

{ #category : #accessing }
GtOpenAIFile >> id: anObject [
	id := anObject
]

{ #category : #accessing }
GtOpenAIFile >> isAssistantsOutput [
	^ self purpose = 'assistants-output'
]

{ #category : #accessing }
GtOpenAIFile >> isError [
	^ self status = 'error'
]

{ #category : #accessing }
GtOpenAIFile >> isFinetuningResults [
	^ self purpose = 'fine-tune-results'
]

{ #category : #accessing }
GtOpenAIFile >> isForAssistants [
	^ self purpose = 'assistants'
]

{ #category : #accessing }
GtOpenAIFile >> isForFinetuning [
	^ self purpose = 'fine-tune'
]

{ #category : #accessing }
GtOpenAIFile >> isProcessed [
	^ self status = 'processed'
]

{ #category : #accessing }
GtOpenAIFile >> isUploaded [
	^ self status = 'uploaded'
]

{ #category : #accessing }
GtOpenAIFile >> purpose [
	^ purpose
]

{ #category : #accessing }
GtOpenAIFile >> purpose: anObject [
	purpose := anObject
]

{ #category : #accessing }
GtOpenAIFile >> status [
	^ status
]

{ #category : #accessing }
GtOpenAIFile >> status: anObject [
	status := anObject
]

{ #category : #accessing }
GtOpenAIFile >> statusDetails [
	^ statusDetails
]

{ #category : #accessing }
GtOpenAIFile >> statusDetails: anObject [
	statusDetails := anObject
]
