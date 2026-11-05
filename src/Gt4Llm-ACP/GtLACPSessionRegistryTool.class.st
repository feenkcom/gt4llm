"
I present an ACP session registry as a Phlow tool.
"
Class {
	#name : #GtLACPSessionRegistryTool,
	#superclass : #GtPhlowTool,
	#instVars : [
		'registry'
	],
	#category : #'Gt4Llm-ACP-UI'
}

{ #category : #'instance creation' }
GtLACPSessionRegistryTool class >> forRegistry: aRegistry [
	^ self new registry: aRegistry
]

{ #category : #converting }
GtLACPSessionRegistryTool >> asElementDo: aBlock [
	| element |
	element := GtLACPSessionRegistryToolElement new registry: self registry.
	^ aBlock cull: element cull: self
]

{ #category : #accessing }
GtLACPSessionRegistryTool >> icon [
	^ BrGlamorousVectorIcons chat
]

{ #category : #accessing }
GtLACPSessionRegistryTool >> name [
	^ 'ACP Sessions'
]

{ #category : #accessing }
GtLACPSessionRegistryTool >> object [
	^ self registry
]

{ #category : #accessing }
GtLACPSessionRegistryTool >> object: aRegistry [
	self registry: aRegistry
]

{ #category : #accessing }
GtLACPSessionRegistryTool >> registry [
	^ registry
]

{ #category : #accessing }
GtLACPSessionRegistryTool >> registry: aRegistry [
	registry := aRegistry
]

{ #category : #accessing }
GtLACPSessionRegistryTool >> tabLook [
	^ BrGlamorousTabSwitcherWithIconAptitude
]
