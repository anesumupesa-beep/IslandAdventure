/* Island Escape Adventures - Custom JavaScript */

$(document).ready(function () {

    // Auto-dismiss alerts after 4 seconds
    setTimeout(function () {
        $('.alert').fadeOut('slow');
    }, 4000);

    // Confirm before delete actions
    $('[data-confirm]').on('click', function (e) {
        var msg = $(this).data('confirm') || 'Are you sure?';
        if (!confirm(msg)) {
            e.preventDefault();
            return false;
        }
    });

    // Highlight active nav link based on current page
    var currentPage = window.location.pathname.toLowerCase();
    $('.navbar-nav .nav-link').each(function () {
        var href = $(this).attr('href');
        if (href && currentPage.indexOf(href.replace('~/', '').toLowerCase()) !== -1) {
            $(this).addClass('active');
        }
    });

    // Cart quantity: prevent values less than 1
    $(document).on('change', '.cart-qty-input', function () {
        if (parseInt($(this).val()) < 1) {
            $(this).val(1);
        }
    });

    // Smooth scroll for anchor links
    $('a[href^="#"]').on('click', function (e) {
        var target = $($(this).attr('href'));
        if (target.length) {
            e.preventDefault();
            $('html, body').animate({ scrollTop: target.offset().top - 70 }, 400);
        }
    });

    // Print button for purchase history
    $('#btnPrint').on('click', function () {
        window.print();
    });

});
