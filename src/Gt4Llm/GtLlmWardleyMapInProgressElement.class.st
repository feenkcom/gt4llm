Class {
	#name : #GtLlmWardleyMapInProgressElement,
	#superclass : #BlElement,
	#traits : 'TGtWithWardleyMapDecoratorViewModel + TBrLayoutResizable',
	#classTraits : 'TGtWithWardleyMapDecoratorViewModel classTrait + TBrLayoutResizable classTrait',
	#category : #'Gt4Llm-Domain - Wardley Map'
}

{ #category : #initialization }
GtLlmWardleyMapInProgressElement >> defaultLayout [
	^ BlLinearLayout horizontal
]

{ #category : #initialization }
GtLlmWardleyMapInProgressElement >> initialize [
	super initialize.
	self
		fitContent;
		padding: (BlInsets all: 5);
		addChild: BrGlamorousVectorIcons refresh asElement;
		addChild: (BrLabel new
				aptitude: BrGlamorousLabelAptitude new glamorousCodeFontAndSmallSize;
				text: 'Waiting for LLM...')
]

{ #category : #'api - wardley map decorator model' }
GtLlmWardleyMapInProgressElement >> onWardleyMapDecoratorViewModelChanged [
	"Is sent when a new wardleyMapDecorator view model is assigned to the element"

	
]

{ #category : #'event handling' }
GtLlmWardleyMapInProgressElement >> onWardleyMapDecoratorViewModelRemoved [
	self removeFromParent.
	self unsubscribeFromWardleyMapDecoratorViewModel.
]

{ #category : #'event handling' }
GtLlmWardleyMapInProgressElement >> onWardleyMapDecoratorViewModelRemoved: anAnnouncement [
	BlTaskAction
		enqueueElement: self
		action: [ self onWardleyMapDecoratorViewModelRemoved ]
]

{ #category : #'api - wardley map decorator model' }
GtLlmWardleyMapInProgressElement >> subscribeToWardleyMapDecoratorViewModel [
	"Is sent after a new wardleyMapDecorator view model is assigned to the element.
	It is required to unsubscribe from the view model by implementing
	#unsubscribeFromWardleyMapDecoratorViewModel if element subscribes to them"
	
	self wardleyMapDecoratorViewModel weak
		when: GtWardleyMapDecoratorViewModelRemoved
		send: #onWardleyMapDecoratorViewModelRemoved:
		to: self.
]

{ #category : #'api - wardley map decorator model' }
GtLlmWardleyMapInProgressElement >> unsubscribeFromWardleyMapDecoratorViewModel [
	"Is sent before a new wardleyMapDecorator view model is assigned to the element.
	Elements that subscribe to wardleyMapDecorator view model are required to implement this methods"
	
	self wardleyMapDecoratorViewModel unsubscribe: self
]
