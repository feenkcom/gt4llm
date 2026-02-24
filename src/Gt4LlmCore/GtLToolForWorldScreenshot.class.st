Class {
	#name : #GtLToolForWorldScreenshot,
	#superclass : #GtLAbstractPlainSchemaFunctionTool,
	#instVars : [
		'worldElementProvider',
		'pngDataProvider'
	],
	#category : #'Gt4LlmCore-Tools'
}

{ #category : #accessing }
GtLToolForWorldScreenshot >> description [
	^ 'Capture the currently focused window or Glamorous Toolkit as a PNG screenshot and return the Base64 encoding.'
]

{ #category : #private }
GtLToolForWorldScreenshot >> focusedWorldElement [
	^ self worldElementProvider
		ifNotNil: [ :provider | provider value ]
		ifNil: [ GtWorldElement allInstances detect: [ :each | true ] ifNone: [ nil ] ]
]

{ #category : #accessing }
GtLToolForWorldScreenshot >> name [
	^ 'worldScreenshot'
]

{ #category : #accessing }
GtLToolForWorldScreenshot >> parametersDescription [
	^ #()
]

{ #category : #private }
GtLToolForWorldScreenshot >> pngByteArrayFor: aWorldElement [
	| form |
	form := BlExporter png
			element: aWorldElement;
			doExport: [ :aCanvas | aCanvas asForm ].
	^ ByteArray
		streamContents: [ :out | PNGReadWriter putForm: form onStream: out ]
]

{ #category : #accessing }
GtLToolForWorldScreenshot >> pngDataProvider [
	^ pngDataProvider
]

{ #category : #accessing }
GtLToolForWorldScreenshot >> pngDataProvider: aBlock [
	pngDataProvider := aBlock
]

{ #category : #private }
GtLToolForWorldScreenshot >> privatePerformToolCall: aToolCall [
	| worldElement |
	worldElement := self focusedWorldElement.
	worldElement
		ifNil: [ ^ GtLProblemDomainObject new
				description: 'No focused GtWorldElement is currently available for capturing a screenshot.';
				yourself ].
	^ [ GtLWorldScreenshotDataDomainObject new
		bytes: (self pngByteArrayFor: worldElement) ]
		on: Error
		do: [ :ex | 
			GtLExceptionDomainObject new
				freeze: ex;
				description: 'Failed to capture a GtWorldElement screenshot' ]
]

{ #category : #accessing }
GtLToolForWorldScreenshot >> worldElementProvider [
	^ worldElementProvider
]

{ #category : #accessing }
GtLToolForWorldScreenshot >> worldElementProvider: aBlock [
	worldElementProvider := aBlock
]
