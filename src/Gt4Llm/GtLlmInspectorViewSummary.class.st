Class {
	#name : #GtLlmInspectorViewSummary,
	#superclass : #Object,
	#instVars : [
		'selector',
		'code',
		'viewClass'
	],
	#category : #'Gt4Llm-Summarizer'
}

{ #category : #accessing }
GtLlmInspectorViewSummary >> code [
	^ code
]

{ #category : #accessing }
GtLlmInspectorViewSummary >> code: anObject [
	code := anObject
]

{ #category : #accessing }
GtLlmInspectorViewSummary >> gtCodeFor: aView [
	<gtView>
	^ aView textEditor
		title: 'Code';
		priority: 1;
		text: [ self code ];
		aptitude: [ BrGlamorousCodeEditorAptitude ];
		styler: [ (GtCompositeSmaCCASTStyler forParser: GtPharoParser)
				stylers: {GtSmaCCPharoStyler new.
						GtPharoDynamicHighlightStyler new} ]
]

{ #category : #accessing }
GtLlmInspectorViewSummary >> selector [
	^ selector
]

{ #category : #accessing }
GtLlmInspectorViewSummary >> selector: anObject [
	selector := anObject
]

{ #category : #accessing }
GtLlmInspectorViewSummary >> summaryString [
	^ '```smalltalk-method
' , self viewClass asString, '
', self code
		, '
```'
]

{ #category : #accessing }
GtLlmInspectorViewSummary >> viewClass [
	^ viewClass
]

{ #category : #accessing }
GtLlmInspectorViewSummary >> viewClass: anObject [
	viewClass := anObject
]
