"
I present an ACP session using the Phlow chat tool structure: a labeled header, collected object views in tabs, and a collapsed playground. I specialize the ACP view collection and omit GtLChat-specific object storage and summarizer integration.
"
Class {
	#name : #GtLACPChatToolElement,
	#superclass : #GtPhlowChatToolElement,
	#category : #'Gt4Llm-ACP-UI'
}

{ #category : #initialization }
GtLACPChatToolElement >> buildToolLabel [
 ^ super buildToolLabel text: 'ACP Chat'; yourself
]

{ #category : #updating }
GtLACPChatToolElement >> collectToolViews [
 | views |
 views := GtPhlowViewsCollector new
  fromObject: self chat;
  pragmaNames: GtLSettings messageViewPragmaNames;
  collect.
 GtPhlowUtility sortByPriority: views.
 ^ views
]

{ #category : #accessing }
GtLACPChatToolElement >> gtInspectorTargetModels [
 ^ { self chat }
]

{ #category : #initialization }
GtLACPChatToolElement >> initialize [
 super initialize.
 self phlow
  accessTool: (GtPhlowToolClassType forClass: GtLACPSession)
  viewModel: #chat
  object: #chat
]

{ #category : #updating }
GtLACPChatToolElement >> updateContainedViews [
 | compositeView tabGroup |
 self chat ifNil: [
  self viewsContainerElement removeChildren.
  ^ self ].
 compositeView := GtPhlowCompositeView new views: self collectToolViews.
 tabGroup := compositeView asElementDo: [ :element | element ].
 self viewsContainerElement removeChildren; addChild: tabGroup
]
