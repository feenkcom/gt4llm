Class {
	#name : #GtLClassCommentChangeResult,
	#superclass : #Object,
	#instVars : [
		'updatedClass',
		'status',
		'oldClassComment',
		'newClassComment'
	],
	#category : #'Gt4LlmCore-Magritte Objects'
}

{ #category : #magritte }
GtLClassCommentChangeResult >> changedClassNameDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Class name';
		accessor: #className;
		beRequired
]

{ #category : #accessing }
GtLClassCommentChangeResult >> className [
	^ self updatedClass name
]

{ #category : #accessing }
GtLClassCommentChangeResult >> newClassComment [
	^ newClassComment
]

{ #category : #accessing }
GtLClassCommentChangeResult >> newClassComment: anObject [
	newClassComment := anObject
]

{ #category : #accessing }
GtLClassCommentChangeResult >> oldClassComment [
	^ oldClassComment
]

{ #category : #accessing }
GtLClassCommentChangeResult >> oldClassComment: anObject [
	oldClassComment := anObject
]

{ #category : #accessing }
GtLClassCommentChangeResult >> status [
	^ status
]

{ #category : #accessing }
GtLClassCommentChangeResult >> status: aString [
	status := aString
]

{ #category : #magritte }
GtLClassCommentChangeResult >> statusDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Status';
		accessor: #status;
		beRequired
]

{ #category : #accessing }
GtLClassCommentChangeResult >> updatedClass [
	^ updatedClass
]

{ #category : #accessing }
GtLClassCommentChangeResult >> updatedClass: aClass [
	updatedClass := aClass
]
