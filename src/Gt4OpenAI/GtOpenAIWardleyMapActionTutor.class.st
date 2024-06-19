Class {
	#name : #GtOpenAIWardleyMapActionTutor,
	#superclass : #GtOpenAIActionTutor,
	#category : #'Gt4OpenAI-Examples - Wardley Map'
}

{ #category : #accessing }
GtOpenAIWardleyMapActionTutor >> addChat [
	| aChat |
	aChat := GtOpenAIWardleyMapActionAssistantChat new
			assistant: self assistant;
			actions: actions;
			pipeline: pipelineBuilder value.
	chats add: aChat.

	^ aChat
]

{ #category : #accessing }
GtOpenAIWardleyMapActionTutor >> connectionAction [
	^ GtLlmTutorAction new
		name: 'Add a new connected node';
		description: 'Adds a new node that is connected to an already existing node. It MUST consider the context of the map topic. It MUST return the entirety of the state.';
		format: 'Add a new connected node to `{1}`';
		examples: {GtLlmTutorActionExample new
					instruction: 'Add a new connected node to `Platform`';
					input: '```topic
Cloud computing
```
```node
{''name'': ''Platform'', ''evolution'': 0.3, ''visibility'': 0.4}
```';
					output: '```action
Add a new connected node
```
```topic
Cloud computing
```
```node
{''name'': ''Platform'', ''evolution'': 0.3, ''visibility'': 0.4}
{''name'': ''Compute'', ''evolution'': 0.7, ''visibility'': 0.1}
```
```connection
{''from'': ''Platform'', ''to'': ''Compute''}
```'.
				GtLlmTutorActionExample new
					instruction: 'Add a new connected node to `Regulator`';
					input: '```action
Add a new connected node
```
```topic
Cloud computing
```
```node
{''name'': ''Regulator'', ''evolution'': 0.6, ''visibility'': 0.2}
```';
					output: '```node
{''name'': ''Regulator'', ''evolution'': 0.6, ''visibility'': 0.2}
{''name'': ''Audit'', ''evolution'': 0.7, ''visibility'': 0.1}
```
```connection
{''from'': ''Audit'', ''to'': ''Regulator''}
```'}
]

{ #category : #accessing }
GtOpenAIWardleyMapActionTutor >> explanationAction [
	^ GtLlmTutorAction new
		name: 'Explain a node';
		description: 'Explains what a node means and why it is on the map using human language.';
		format: 'Explain the node `{1}`';
		examples: {GtLlmTutorActionExample new
					instruction: 'Explain `Compute`';
					input: '```topic
Cloud computing
```
```node
{''name'': ''Compute'', ''evolution'': 0.3, ''visibility'': 0.4}
```';
					output: '```action
Explain a node
```
```topic
Cloud computing
```
```node
{''name'': ''Compute'', ''evolution'': 0.3, ''visibility'': 0.4}
```
```explanation
In the context of this Wardley Map on Cloud Computing, the node `Compute` refers to the computing resources and capabilities provided as part of cloud services. This encompasses the virtualized processing power (CPUs, GPUs) that can be scaled up or down on demand to meet the needs of applications or services running in the cloud. The `Compute` node is fundamental to cloud computing, as it allows for flexible, efficient, and scalable computing solutions that can be tailored to the specific requirements of businesses and developers.

The presence of `Compute` in a cloud computing map highlights its role as a core component of the cloud value chain, directly supporting various higher-level services and applications that depend on reliable and scalable computing resources. It could be connected to nodes representing services that leverage these computing resources, such as web hosting, data analytics platforms, or any software-as-a-service (SaaS) applications, indicating a dependency relationship where these services rely on the underlying compute capabilities to function effectively.

In summary, `Compute` signifies the provisioning of raw processing power in the cloud, which is pivotal to the delivery of a wide range of cloud-based services and applications, illustrating the utility and flexibility offered by cloud computing paradigms.
```'}
]

{ #category : #accessing }
GtOpenAIWardleyMapActionTutor >> initialAction [
	^ GtLlmTutorAction new
		name: 'Create a set of nodes';
		description: 'Creates a set of nodes based on a given topic, filling topic, nodes, and connections with sensible data. If a map topic was already set, it is overridden. The rest of the map is extended.';
		format: 'Create a set of nodes on {1}';
		examples: {GtLlmTutorActionExample new
					instruction: 'Create a set of nodes on Key components for a drone delivery service';
					input: '```topic
```
```node
```
```connection
```';
					output: '```action
Create a set of nodes
```
```topic
Key components for a drone delivery service
```
```node
{"name":"Drone delivery platform","evolution":0.7,"visibility":0.7}
{"name":"Communication system","evolution":0.4,"visibility":0.6}
{"name":"Regulatory compliance","evolution":0.3,"visibility":0.8}
{"name":"Software development","evolution":0.3,"visibility":0.2}
{"name":"Computing resources","evolution":0.2,"visibility":0.3}
{"name":"Customer need","evolution":0.9,"visibility":0.8}
{"name":"Power supply and charging stations","evolution":0.2,"visibility":0.5}
{"name":"Weather monitoring system","evolution":0.4,"visibility":0.5}
{"name":"Navigation and GPS","evolution":0.3,"visibility":0.6}
{"name":"Data storage","evolution":0.2,"visibility":0.4}
{"name":"Cybersecurity measures","evolution":0.1,"visibility":0.6}
{"name":"Drones","evolution":0.6,"visibility":0.6}
{"name":"Maintenance service for drones","evolution":0.5,"visibility":0.4}
{"name":"Air traffic control system","evolution":0.2,"visibility":0.7}
{"name":"Automated package handling system","evolution":0.5,"visibility":0.6}
```
```connection
{"from": "Customer need", "to": "Drone delivery platform"}
{"from": "Drone delivery platform", "to": "Drones"}
{"from": "Drones", "to": "Maintenance service for drones"}
{"from": "Drone delivery platform", "to": "Regulatory compliance"}
{"from": "Drone delivery platform", "to": "Weather monitoring system"}
{"from": "Drones", "to": "Navigation and GPS"}
{"from": "Drones", "to": "Air traffic control system"}
{"from": "Drone delivery platform", "to": "Automated package handling system"}
{"from": "Drone delivery platform", "to": "Communication system"}
{"from": "Drone delivery platform", "to": "Data storage"}
{"from": "Drone delivery platform", "to": "Computing resources"}
{"from": "Drones", "to": "Power supply and charging stations"}
{"from": "Drone delivery platform", "to": "Software development"}
{"from": "Drone delivery platform", "to": "Cybersecurity measures"}
```'.
				GtLlmTutorActionExample new
					instruction: 'Create a set of nodes on Moldable development';
					input: '```topic
```
```node
```
```connection
```';
					output: '```action
Create a set of nodes
```
```topic
Moldable development
```
```node
{"name":"User Feedback","evolution":0.4,"visibility":0.85}
{"name":"Programming Languages","evolution":0.8,"visibility":0.3}
{"name":"Problem Domain","evolution":0.2,"visibility":0.9}
{"name":"Customization Frameworks","evolution":0.5,"visibility":0.7}
{"name":"Frameworks and Libraries","evolution":0.75,"visibility":0.2}
{"name":"Moldable Tools","evolution":0.4,"visibility":0.8}
{"name":"Developer Skills","evolution":0.3,"visibility":0.7}
{"name":"Development Practices","evolution":0.1,"visibility":0.1}
```
```connection
{"from": "Developer Skills", "to": "Moldable Tools"}
{"from": "Developer Skills", "to": "Programming Languages"}
{"from": "Developer Skills", "to": "Frameworks and Libraries"}
{"from": "User Feedback", "to": "Moldable Tools"}
{"from": "User Feedback", "to": "Customization Frameworks"}
{"from": "Moldable Tools", "to": "Problem Domain"}
{"from": "Customization Frameworks", "to": "Problem Domain"}
{"from": "Development Practices", "to": "Moldable Tools"}
{"from": "Development Practices", "to": "Customization Frameworks"}
```'}
]

{ #category : #accessing }
GtOpenAIWardleyMapActionTutor >> initialize [
	super initialize.

	self initializeFormat.
	self initializeActions.
	self initializePipeline
]

{ #category : #accessing }
GtOpenAIWardleyMapActionTutor >> initializeActions [
	actions addAll: {
		self initialAction.
		self connectionAction.
		self explanationAction.
		self renameAction
	}
]

{ #category : #accessing }
GtOpenAIWardleyMapActionTutor >> initializeFormat [
	format := GtLlmTutorFormat new
			name: 'Wardley Map';
			addComponent: (GtLlmTutorComponent new
					name: 'Topic';
					format: 'Text';
					tag: 'topic';
					example: '```topic
Cloud computing in regulated areas
```');
			addComponent: (GtLlmTutorComponent new
					name: 'Node';
					format: 'JSON';
					tag: 'node';
					example: '```node
{''name'': ''example node'', ''evolution'': 0.1, ''visibility'': 0.3}
```

or, for multiple nodes:
```node
{''name'': ''example node'', ''evolution'': 0.1, ''visibility'': 0.3}
{''name'': ''example node 2'', ''evolution'': 0.5, ''visibility'': 0.2}
```

All connections must go into one node.');
			addComponent: (GtLlmTutorComponent new
					name: 'Connection';
					format: 'JSON';
					tag: 'connection';
					example: '```connection
{''from'': ''example node'', ''to'': ''example node 2''}
```

or, for multiple connections:
```connection
{''from'': ''example node'', ''to'': ''example node 2''}
{''from'': ''example node 3'', ''to'': ''example node 2''}
```

All connections must go into one snippet.');
			addComponent: (GtLlmTutorComponent new
					name: 'Explanation';
					format: 'Text';
					tag: 'explanation';
					example: '```explanation
Human readable text goes here
```')
]

{ #category : #accessing }
GtOpenAIWardleyMapActionTutor >> initializePipeline [
	self
		pipelineBuilder: [ GtLlmContext new
				instance: GtLlmActionWardleyMapCreator new;
				isImmutableInstance: true;
				checker: (GtLlmAlternativeCodeStep new
						addAlternative: GtLlmWardleyMapTopicStep new
							matching: [ :aContext | aContext lastResult isForLanguage: 'topic' ];
						addAlternative: GtLlmWardleyMapPositionedNodeStep new
							matching: [ :aContext | aContext lastResult isForLanguage: 'node' ];
						addAlternative: GtLlmWardleyMapResettingConnectionStep new
							matching: [ :aContext | aContext lastResult isForLanguage: 'connection' ];
						addAlternative: GtLlmWardleyMapExplanationStep new
							matching: [ :aContext | aContext lastResult isForLanguage: 'explanation' ]) ]
]

{ #category : #accessing }
GtOpenAIWardleyMapActionTutor >> renameAction [
	^ GtLlmTutorAction new
		name: 'Rename a node';
		description: 'Proposes a sensible number of alternative names for nodes (less than ten, but more than one).';
		format: 'Rename the node `{1}`';
		examples: {GtLlmTutorActionExample new
					instruction: 'Rename the node `Compute`';
					input: '```topic
Cloud computing
```
```node
{''name'': ''Compute'', ''evolution'': 0.3, ''visibility'': 0.4}
```';
					output: '```action
Rename a node
```
```topic
Cloud computing
```
```node
{''name'': ''Compute'', ''evolution'': 0.3, ''visibility'': 0.4, ''alternative_names'': [''Computational Resources'', ''Resources'']}
```'.
				GtLlmTutorActionExample new
					instruction: 'Rename the node `Furnace`';
					input: '```topic
Appliances
```
```node
{''name'': ''Furnace'', ''evolution'': 0.9, ''visibility'': 0.9}
```';
					output: '```action
Rename a node
```
```topic
Appliances
```
```node
{''name'': ''Furnace'', ''evolution'': 0.9, ''visibility'': 0.9, ''alternative_names'': [''Boiler'', ''Heater'', ''Incinerator'', ''Kiln'', ''Stove'']}
```'}
]
