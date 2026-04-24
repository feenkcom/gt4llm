"
Represents a code change detected by a tool call summarizer, linking the change kind, the change result and the originating tool call.
"
Class {
	#name : #GtLSummarizerCodeChange,
	#superclass : #Object,
	#instVars : [
		'label',
		'changeResult',
		'toolCall'
	],
	#category : 'Gt4LlmCore-Summaries'
}

{ #category : #accessing }
GtLSummarizerCodeChange >> changeResult [
	^ changeResult
]

{ #category : #accessing }
GtLSummarizerCodeChange >> changeResult: anObject [
	changeResult := anObject
]

{ #category : #printing }
GtLSummarizerCodeChange >> gtDisplayOn: aStream [
	aStream
		nextPutAll: self label;
		nextPutAll: ': ';
		nextPutAll: self changeResult gtDisplayString
]

{ #category : #'gt-view' }
GtLSummarizerCodeChange >> gtViewChangeDescriptionElement [
	^ self changeResult gtViewChangeDescriptionElement
]

{ #category : #'gt-view' }
GtLSummarizerCodeChange >> gtViewChangeEditTime [
	^ DateAndTime now
]

{ #category : #'gt-view' }
GtLSummarizerCodeChange >> gtViewChangeHistoryChildren [
	^ #()
]

{ #category : #'gt-view' }
GtLSummarizerCodeChange >> gtViewChangeIcon [
	^ self changeResult gtViewChangeIcon
]

{ #category : #'gt-view' }
GtLSummarizerCodeChange >> gtViewChangesCount [
	^ 0
]

{ #category : #'gt-view' }
GtLSummarizerCodeChange >> gtViewsInContext: aPhlowContext [
	| collectedViews |
	collectedViews := Array
			streamContents: [ :aStream | 
				aStream nextPutAll: (super gtViewsInContext: aPhlowContext).
				changeResult
					ifNotNil: [ :aModel | 
						aStream
							nextPutAll: (GtPhlowViewsCollector new
									fromObject: aModel;
									pragmaNames: #(gtCodeChangeView);
									collect) ] ].

	GtPhlowUtility sortByPriority: collectedViews.

	^ collectedViews
]

{ #category : #testing }
GtLSummarizerCodeChange >> isClassChangeResult [
	^ self changeResult isClassChangeResult
]

{ #category : #testing }
GtLSummarizerCodeChange >> isClassCommentChangeResult [
	^ self changeResult isClassCommentChangeResult
]

{ #category : #testing }
GtLSummarizerCodeChange >> isMethodAdditionResult [
	^ self changeResult isMethodAdditionResult
]

{ #category : #testing }
GtLSummarizerCodeChange >> isMethodChangeResult [
	^ self changeResult isMethodChangeResult
]

{ #category : #testing }
GtLSummarizerCodeChange >> isMethodModificationResult [
	^ self changeResult isMethodModificationResult
]

{ #category : #testing }
GtLSummarizerCodeChange >> isMethodRemovalResult [
	^ self changeResult isMethodRemovalResult
]

{ #category : #accessing }
GtLSummarizerCodeChange >> label [
	^ label
]

{ #category : #accessing }
GtLSummarizerCodeChange >> label: aString [
	label := aString
]

{ #category : #accessing }
GtLSummarizerCodeChange >> toolCall [
	^ toolCall
]

{ #category : #accessing }
GtLSummarizerCodeChange >> toolCall: aToolCall [
	toolCall := aToolCall
]
