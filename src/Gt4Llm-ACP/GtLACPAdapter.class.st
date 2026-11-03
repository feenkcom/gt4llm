"
I describe how to launch an ACP adapter. Client settings keep agent preferences and optional executable/argument overrides, while the ACP connection and stdio transport are shared.
"
Class {
	#name : #GtLACPAdapter,
	#superclass : #GtLACPObject,
	#category : #'Gt4Llm-ACP-Core'
}

{ #category : #accessing }
GtLACPAdapter >> arguments [
	self subclassResponsibility
]

{ #category : #accessing }
GtLACPAdapter >> displayName [
	self subclassResponsibility
]

{ #category : #accessing }
GtLACPAdapter >> executable [
	self subclassResponsibility
]

{ #category : #printing }
GtLACPAdapter >> gtDisplayOn: aStream [
	aStream nextPutAll: self displayName
]

{ #category : #views }
GtLACPAdapter >> gtLaunchFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Launch';
		priority: 0;
		items: [ {'Executable' -> self executable.
				'Arguments' -> self arguments} ];
		column: 'Setting' text: #key;
		column: 'Value' text: [ :entry | entry value printString ];
		send: #value
]
