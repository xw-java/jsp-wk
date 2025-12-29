<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<div class="carousel-container" id="mainCarousel">
    <div class="carousel-slide active" style="background: linear-gradient(135deg, #00C9FF 0%, #92FE9D 100%);">
        <div class="carousel-caption">
            <h2>全新 iPhone 15 Pro</h2>
            <p>钛金属，强悍登场。A17 Pro 芯片，性能怪兽。</p>
            <a href="searchMobile.jsp?searchMess=iPhone" class="btn btn-light" style="background:white; color:#333; margin-top:15px; padding:12px 30px;">立即探索</a>
        </div>
    </div>

    <div class="carousel-slide" style="background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);">
        <div class="carousel-caption">
            <h2>华为 Mate 60 Pro</h2>
            <p>同心聚力，连接未来。卫星通话，遥遥领先。</p>
            <a href="searchMobile.jsp?searchMess=Huawei" class="btn btn-light" style="background:white; color:#333; margin-top:15px; padding:12px 30px;">查看详情</a>
        </div>
    </div>

    <div class="carousel-slide" style="background: linear-gradient(135deg, #89f7fe 0%, #66a6ff 100%);">
        <div class="carousel-caption">
            <h2>小米 14 Ultra</h2>
            <p>徕卡光学，移动影像新层次。让真实发生。</p>
            <a href="searchMobile.jsp?searchMess=Xiaomi" class="btn btn-light" style="background:white; color:#333; margin-top:15px; padding:12px 30px;">立即抢购</a>
        </div>
    </div>

    <button class="carousel-btn carousel-prev" onclick="moveSlide(-1)">&#10094;</button>
    <button class="carousel-btn carousel-next" onclick="moveSlide(1)">&#10095;</button>
</div>

<script>
    let currentSlide = 0;
    const slides = document.querySelectorAll('.carousel-slide');

    function showSlide(n) {
        slides.forEach(slide => slide.classList.remove('active'));
        currentSlide = (n + slides.length) % slides.length;
        slides[currentSlide].classList.add('active');
    }

    function moveSlide(n) {
        showSlide(currentSlide + n);
    }

    // 自动轮播
    setInterval(() => {
        moveSlide(1);
    }, 5000);
</script>
