jQuery(document).ready(function($) {


	var mastheadheight = $('.ds-header').outerHeight();
	
	$(".ds-banner,.ds-main-section").css("margin-top" , mastheadheight);

	$(window).scroll(function(){
	    if ($(window).scrollTop() >= 10) {
	        $('.ds-header').addClass('ds-fixed-header');
	    }
	    else {
	        $('.ds-header').removeClass('ds-fixed-header');
	    }
	}).scroll();


});
/*
<script>
    document.addEventListener('DOMContentLoaded', function () {
        const lambdaUrl = 'https://gy4ifvuhxzk2hmbzs2gwqkxnyy0zblfn.lambda-url.us-east-1.on.aws/';

        fetch(lambdaUrl)
            .then(response => response.json())
            .then(data => {
                // Create a new label element
                const label = document.createElement('div');
                label.classList.add('lambda-data-label');
                label.innerText = 'Visits: ' + JSON.stringify(data, null, 2);

                // Append the label to the body or any other desired location
                document.body.appendChild(label);
            })
            .catch(error => {
                console.error('Error fetching data:', error);
                // Create an error label if there is an issue
                const errorLabel = document.createElement('div');
                errorLabel.classList.add('error-label');
                errorLabel.innerText = 'Error fetching data';

                // Append the error label to the body or any other desired location
                document.body.appendChild(errorLabel);
            });
    });
</script>
*/
