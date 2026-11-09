"
I launch an npm ACP adapter using npx. The npm package identifies the implementation, independently of the agent client.
"
Class {
	#name : #GtLACPNpmAdapter,
	#superclass : #GtLACPAdapter,
	#instVars : [
		'packageName'
	],
	#category : #'Gt4Llm-ACP-Core'
}

{ #category : #'instance creation' }
GtLACPNpmAdapter class >> package: aPackageName [
	^ self new
		packageName: aPackageName;
		yourself
]

{ #category : #accessing }
GtLACPNpmAdapter >> arguments [
	packageName isEmptyOrNil
		ifTrue: [ self error: 'An npm adapter package is required' ].
	^ {'--yes'.
		packageName}
]

{ #category : #accessing }
GtLACPNpmAdapter >> displayName [
	^ packageName
]

{ #category : #accessing }
GtLACPNpmAdapter >> executable [
	^OSPlatform current isWindows 
		ifTrue: ['npx.cmd'] 
		ifFalse: ['npx']
]

{ #category : #accessing }
GtLACPNpmAdapter >> packageName [
	^ packageName
]

{ #category : #accessing }
GtLACPNpmAdapter >> packageName: aString [
	packageName := aString
]
