// main.js

function init() {
	addConfirmations();
}

function addConfirmations() {
	const confirmables = document.querySelectorAll("form[data-confirm]");
	confirmables.forEach((confirmable) => {
		const confirm = document.createElement("dialog");
		const message = document.createElement("p");
		const cancel  = document.createElement("button");
		const accept  = document.createElement("button");
		cancel.type = "button";
		cancel.className = "yes"
		accept.className = "no"
		message.innerText = confirmable.dataset.confirm;
		cancel.innerText = confirmable.dataset.cancel;
		accept.innerText = confirmable.dataset.accept;
		confirm.appendChild(message);
		confirm.appendChild(cancel);
		confirm.appendChild(accept);
		confirmable.appendChild(confirm);
		confirmable.onsubmit = (event) => {
			event.preventDefault();
			confirm.showModal();
		}
		cancel.onclick = (event) => {
			confirm.close();
		}
		accept.onclick = () => {
			confirmable.submit();
		}
	});
}

if (document.readyState == "loading") {
	document.addEventListener("DOMContentLoaded", init);
} else {
	init();
}