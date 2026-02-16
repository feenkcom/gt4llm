Class {
	#name : #GtLRewriteRule,
	#superclass : #Object,
	#instVars : [
		'from',
		'to',
		'isMethodPattern'
	],
	#category : #Gt4LlmCore
}

{ #category : #'instance creation' }
GtLRewriteRule class >> from: aFrom to: aTo [
	^ self new
		from: aFrom;
		to: aTo;
		yourself
]

{ #category : #magritte }
GtLRewriteRule >> descriptionContainer [
	^ super descriptionContainer
		comment: 'The rewrite rule with from and to patterns.'
]

{ #category : #accessing }
GtLRewriteRule >> from [
	^ from
]

{ #category : #accessing }
GtLRewriteRule >> from: aString [
	from := aString
]

{ #category : #magritte }
GtLRewriteRule >> fromDescription [
	<magritteDescription>
	^ MAStringDescription new
		accessor: #from;
		comment: 'The source pattern to match.';
		beRequired
]

{ #category : #printing }
GtLRewriteRule >> gtDisplayOn: aStream [
	aStream
		nextPutAll: 'Rewrite rule from '; 
		nextPutAll: from asString;
		nextPutAll: ' to ';
		nextPutAll: to asString
]

{ #category : #'gt-view' }
GtLRewriteRule >> gtRewriteSnippetFor: aView [
	<gtView>
	<gtLlmView>
	^ aView forward
		title: 'Rewrite';
		priority: 1;
		object: [ LePharoRewriteSnippet new
				search: self from;
				replace: self to;
				isMethodPattern: self isMethodPattern;
				yourself ];
		view: #gtLiveFor:
]

{ #category : #accessing }
GtLRewriteRule >> isMethodPattern [
	<return: #Boolean>
	^ isMethodPattern ifNil: [ false ]
]

{ #category : #accessing }
GtLRewriteRule >> isMethodPattern: aBoolean [
	isMethodPattern := aBoolean
]

{ #category : #magritte }
GtLRewriteRule >> isMethodPatternDescription [
	"<magritteDescription>"
	^ MABooleanDescription new
		accessor: #isMethodPattern;
		comment: 'Whether the rewrite rule applies to a whole method.'
]

{ #category : #accessing }
GtLRewriteRule >> to [
	^ to
]

{ #category : #accessing }
GtLRewriteRule >> to: aString [
	to := aString
]

{ #category : #magritte }
GtLRewriteRule >> toDescription [
	<magritteDescription>
	^ MAStringDescription new
		accessor: #to;
		comment: 'The replacement pattern.';
		beRequired
]
